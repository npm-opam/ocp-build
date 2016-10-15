type t
exception LabelMismatch of t * string
exception MissingLabel of t * string

val create : string ->
  string list ->
  (string * string) list option ->
  t
val load : t -> (string * string) list -> string

val labels : t -> string list
val content : t -> string


module Set : sig
  type t
  val of_file : string -> t
  val of_string : string -> t
end

val get : Set.t -> string -> string list -> t

