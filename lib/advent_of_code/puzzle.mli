type t

val create : event:Event.t -> day:int -> (t, string) result
val get_current : unit -> t option
val event : t -> Event.t
val day : t -> int
