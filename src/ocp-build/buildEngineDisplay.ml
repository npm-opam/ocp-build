(******************************************************************************)
(*                                                                            *)
(*                          TypeRex OCaml Tools                               *)
(*                                                                            *)
(*                               OCamlPro                                     *)
(*                                                                            *)
(*    Copyright 2011-2012 OCamlPro                                            *)
(*    All rights reserved.  See accompanying files for the terms under        *)
(*    which this file is distributed. In doubt, contact us at                 *)
(*    contact@ocamlpro.com (http://www.ocamlpro.com/)                         *)
(*                                                                            *)
(******************************************************************************)


(* open BuildBase *)
(* open Stdlib2 *)
open BuildEngineTypes
open BuildTerm

let verbose =
  DebugVerbosity.add_submodules "B" [ "BED" ];
  DebugVerbosity.verbose [ "BED" ] "BuildEngineDisplay"

let init _b = ()

let string_limit n s =
  let len = String.length s in
  if len <= n then s else
    let s' = if n >= 0 then String.sub s 0 n else "" in
    if n >= 3 then String.blit "..." 0 s' (n-3) 3;
    s'

let pretty_rule_name rule len =
  let f = rule.rule_main_target.file_file in
  let base = File.basename f in
  let dir = File.to_string (File.dirname f) in
  let dir =
    try (* rm first directory (_obuild/) *)
      let i = String.index dir Filename.dir_sep.[0] in
      String.sub dir (i+1) (String.length dir - i - 1)
    with Not_found | Invalid_argument "String.sub" -> dir
  in
  let curlen = String.length base + String.length Filename.dir_sep in
  let dir = string_limit (len - curlen) dir in
  let curlen = curlen + String.length dir in
  let pad = if len > curlen then String.make (len - curlen) ' ' else "" in
  String.concat ""
    [ dir; Filename.dir_sep;
       term_bold (File.basename (File.chop_extension f)); ".";
       String.concat "." (File.extensions f) ; pad ]

let print_stat_line b proc =
  let npar = List.length b.build_stats_running_rules in
  let current_rules =
    string_limit (term.esc_columns - 13 - npar)
      (String.concat " "
         (List.rev_map
            (fun (r,_) -> (Hashtbl.find b.build_rules r).rule_main_target.file_basename)
            b.build_stats_running_rules))
  in
    Printf.eprintf
      "%s[%4d/%4d] %s%s%s %s%s%s%!"
      term.esc_bold
      b.build_stats_executed
      b.build_stats_to_execute
      term.esc_blue_text
      (String.make npar '*')
      term.esc_end
      current_rules
      term.esc_linefeed
      term.esc_killline

let begin_command b proc =
  let r = proc.proc_rule in
  let cmd = match proc.proc_last with
      None -> assert false
    | Some cmd -> cmd
  in
  let cmd_args =
    (BuildEngineRules.command_of_command cmd) @ List.map (BuildEngineRules.argument_of_argument r) cmd.cmd_args
  in
  if verbose 1 && term.esc_ansi then print_stat_line b proc else
  if verbose 2 then begin
    Printf.eprintf "[%d.%d] BEGIN '%s' %s\n%!" r.rule_id proc.proc_step
      (term_escape (String.concat "' '" cmd_args))
    (match cmd.cmd_stdout_pipe with
      None -> ""
      | Some filename -> Printf.sprintf "> '%s'" filename);
  end

let errors = ref []

let print_file message filename =
  let ic = open_in filename in
  let message_printed = ref false in
  begin
    try
      while true do
	let line = input_line ic in
	if not !message_printed then begin
	  message_printed := true;
	  Printf.eprintf "%s\n" message
	end;
	Printf.eprintf "%s\n" line
      done
    with _ -> ()
  end;
  Printf.eprintf "%!";
  close_in ic

let temp_stdout b r =
  Filename.concat b.build_dir_filename
    (Printf.sprintf "rule_%d.stdout" r.rule_id)

let temp_stderr b r =
  Filename.concat b.build_dir_filename
    (Printf.sprintf "rule_%d.stderr" r.rule_id)

let end_command b proc time status =
  match proc.proc_last with
  | None -> assert false
  | Some cmd ->
    let r = proc.proc_rule in
    let cmd_args =
      (BuildEngineRules.command_of_command cmd)
      @ List.map (BuildEngineRules.argument_of_argument r) cmd.cmd_args
    in
    let has_stderr = (Unix.stat (temp_stderr b r)).Unix.st_size > 0 in
    begin
      if verbose 2 then begin
        Printf.eprintf "[%d.%d]   END(%d) '%s'\n%!" r.rule_id proc.proc_step
          status
          (term_escape (String.concat "' '" cmd_args));
      end
      else
        if verbose 1 then
(*          if !color then *)
            Printf.eprintf "%s%2.2fs%s %s %s%s%s\n"
              term.esc_cyan_text time term.esc_end
              (pretty_rule_name r (term.esc_columns - 16))
              (match status, has_stderr with
                 0, true -> term.esc_yellow_text
               | 0, false -> term.esc_green_text
               | _ -> term.esc_red_text)
              (if status = 0 then "[ done ]"
               else "[failed]")
              term.esc_end
(*          else
            let percent = b.build_stats_executed * 100 / b.build_stats_to_execute
            in
            Printf.eprintf "[%3d%%] %-50s %s\n%!" percent
              r.rule_main_target.file_basename
              (if status = 0 then "   OK" else "ERROR") *)
        else
          let point = b.build_stats_executed * 70 / b.build_stats_to_execute
          in
          if point > b.build_stats_lastpoint then begin
            Printf.eprintf ".%!";
            b.build_stats_lastpoint <- point
          end;
    end;
    let str_command =
      term_escape
        (Filename.basename
           (String.concat " " (BuildEngineRules.command_of_command cmd)))
    in
    let color_begin =
      if status = 0 then term.esc_yellow_text
      else term.esc_red_text
    in
    if status <> 0 then
      Printf.eprintf "%s[%d.%d] Command failed:%s '%s'\n" term.esc_red_text r.rule_id proc.proc_step term.esc_end
	     (term_escape (String.concat "' '" cmd_args)) ;
    if cmd.cmd_stdout_pipe = None then
      print_file
        (Printf.sprintf "%s-- stdout of %s --%s" color_begin str_command term.esc_end)
        (temp_stdout b r);
    if has_stderr then
      print_file
        (Printf.sprintf "%s-- stderr of %s --%s" color_begin str_command term.esc_end)
        (temp_stderr b r);
    if term.esc_ansi then print_stat_line b proc;
    if status <> 0 then
      errors :=
	[
	  Printf.sprintf "[%d.%d] '%s'" r.rule_id proc.proc_step
	    (term_escape (String.concat "' '" cmd_args));
	  File.string_of_file (temp_stdout b r);
	  File.string_of_file (temp_stderr b r);
	] :: !errors


let add_error s =  errors := s :: !errors
let has_error () = !errors <> []
let errors () = List.rev !errors
let finish () =
  if verbose 0 && not (verbose 1) then
    Printf.eprintf "Finished\n%!"
