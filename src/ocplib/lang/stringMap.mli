
include Map.S with type key = string and type 'a t = 'a Map.Make(String).t

val of_list: (key * 'a) list -> 'a t
val to_list: 'a t -> (key * 'a) list
val to_list_of_keys: 'a t -> key list
