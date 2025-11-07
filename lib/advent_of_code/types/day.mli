type t

val current : unit -> t option
val of_int : int -> (t, string) result
val int_value : t -> int
