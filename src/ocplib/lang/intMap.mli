
include Map.S with type key = int

val to_list: 'a t -> (int * 'a) list
val to_list1: 'a t -> int list
val to_list2: 'a t -> 'a list

exception MinElt
val min_elt: 'a t -> (key * 'a) option
