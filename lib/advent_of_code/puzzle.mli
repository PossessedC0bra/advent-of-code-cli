type t

val create : event:Event.t -> day:Day.t -> (t, string) result
val of_year_and_day : int -> int -> (t, string) result
val get_current : unit -> t option
val event : t -> Event.t
val day : t -> Day.t
