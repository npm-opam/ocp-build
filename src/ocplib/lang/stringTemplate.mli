type t
exception LabelMismatch of t * string
exception MissingLabel of t * string

val create : string Lazy.t ->
  string list ->
  (string * string) list option ->
  t
val load : t -> (string * string) list -> string

val labels : t -> string list
val content : t -> string
