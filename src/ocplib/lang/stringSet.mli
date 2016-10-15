
include Set.S with type elt = string and type t = Set.Make(String).t

val of_list: elt list -> t
