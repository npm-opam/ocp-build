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
open BuildOCPTypes

type config
type state

val continue_on_ocp_error : bool ref

val initial_state : unit -> state
val copy_state : state -> state
val final_state : state -> final_package array

val empty_config :config
val generated_config :config

val add_primitive : string ->    string list ->

  (env list -> (* all surrounding env, including the second argument ! *)
   env ->
   plist) -> unit

val filesubst : (string * env list) StringSubst.M.subst
val subst_basename : string -> string

val config_get : config -> string -> plist

(*
val translate_expression :
  env -> BuildOCPTree.expression -> plist
val add_project_dep: BuildOCPTypes.package -> bool -> string ->  unit
  (* string package_dependency *)
*)

(*

module MakeParser(S : sig
  type project_info

  val new_project_id : unit -> int
  val register_project : project_info BuildOCPTypes.project -> unit
  val new_project :
    string ->
    string -> string -> project_info  BuildOCPTypes.project
  val register_installed : string -> unit

end) : sig


end

*)

val new_package :
  state ->
  string (* name *) ->
  string (* dirname *) ->
  string (* filename *) ->
  (string * Digest.t option) list (* filenames *) ->
  BuildOCPTypes.package_type ->
  env ->
  BuildOCPTypes.pre_package

val new_package_dep :
  BuildOCPTypes.final_package -> string ->
  env ->
  string BuildOCPTypes.package_dependency

val read_ocamlconf :  state -> config -> string -> config

val check_package : final_package -> unit

type prim

val primitives_help : unit -> (prim * string list) StringMap.t
val eprint_env : string -> env -> unit
val eprint_plist : string -> plist -> unit
