type t

val of_int : int -> (t, string) result
val latest : unit -> t
val int_value : t -> int
