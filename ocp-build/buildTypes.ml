(**************************************************************************)
(*                                                                        *)
(*                              OCamlPro TypeRex                          *)
(*                                                                        *)
(*   Copyright OCamlPro 2011-2016. All rights reserved.                   *)
(*   This file is distributed under the terms of the GPL v3.0             *)
(*      (GNU Public Licence version 3.0).                                 *)
(*                                                                        *)
(*     Contact: <typerex@ocamlpro.com> (http://www.ocamlpro.com/)         *)
(*                                                                        *)
(*  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,       *)
(*  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES       *)
(*  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND              *)
(*  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS   *)
(*  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN    *)
(*  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN     *)
(*  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE      *)
(*  SOFTWARE.                                                             *)
(**************************************************************************)


open StringCompat

type package_type = BuildOCPTypes.package_type =
  | ProgramPackage
  | TestPackage
  | LibraryPackage
  | ObjectsPackage
  | SyntaxPackage
  | RulesPackage


type 'a package_dependency = 'a BuildOCPTypes.package_dependency =
    {
      dep_project : 'a;
      mutable dep_link : bool;
      mutable dep_syntax : bool;
      mutable dep_optional : bool;
      dep_options : BuildValue.Types.env;
    }

type mklib_kind =
    MKLIB_Unix
  | MKLIB_Msvc

and package_info = {
  lib_context : BuildEngineTypes.build_context;
  lib_id : int;
  lib_name : string;
  lib_builder_context : builder_context;
  mutable lib_ready : BuildEngineTypes.build_file list;
  mutable lib_installed : bool;
  mutable lib_install : bool;
  lib_loc : string * int * string;
  mutable lib_options : BuildValue.Types.env;

  mutable lib_version : string;
  mutable lib_dirname : File.t;
  mutable lib_provides : string;
  mutable lib_type : BuildOCPTypes.package_type;
  mutable lib_tag : string;
  mutable lib_meta : bool;
  (* true means that it should be ignored about objects *)
  lib_filename : string;
  lib_source_kind : string;

  lib_node : LinearToposort.node;

  mutable lib_requires : package_info BuildOCPTypes.package_dependency list;
  mutable lib_added : bool;
  lib_src_dir : BuildEngineTypes.build_directory;
  lib_dst_dir : BuildEngineTypes.build_directory;
  lib_mut_dir : BuildEngineTypes.build_directory;

  (* [lib_bundles] specifies the other packages that should be
     uninstalled when this package is uninstalled.

     The field is initialized when installing packages, from the
      "bundle" variables of packages being installed.
  *)
  mutable lib_bundles : package_info list;
}

and builder_context = {
  build_context : BuildEngineTypes.build_context;
  mutable packages_by_name : package_info StringMap.t;
  all_projects : (int, package_info) Hashtbl.t;
  config_filename_validated_table : (string, BuildEngineTypes.build_file) Hashtbl.t;
  uniq_rules : (string, BuildEngineTypes.build_rule) Hashtbl.t;
}
