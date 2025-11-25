(** Represents a puzzle for a given day in an Advent of Code event. *)
type t

(** [create ~event ~day] creates a puzzle for the given [day] in the given
    [event]. The day must be between 1 and 25. *)
val create : event:Event.t -> day:int -> (t, string) result

(** [get_current ()] returns the current puzzle. This is the puzzle for the
    current day, if the current date is in December. Otherwise, it is [None]. *)
val get_current : unit -> t option

(** [event t] returns the event of the puzzle [t]. *)
val event : t -> Event.t

(** [day t] returns the day of the puzzle [t]. *)
val day : t -> int
