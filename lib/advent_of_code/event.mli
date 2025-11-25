(** Represents an Advent of Code event. *)
type t

(** The time zone offset in seconds for the Advent of Code event. Puzzles are
    released at midnight EST, which is UTC-5. For more information see {{:https://adventofcode.com/2025/about#faq_unlocktime}Advent of Code FAQ - Unlock time}
*)
val publish_time_zone_offset_s : int

(** [create year] creates an event for the given [year]. The year must be
    between 2015 and the current year. *)
val create : int -> (t, string) result

(** [year t] returns the year of the event [t]. *)
val year : t -> int

(** [get_latest ()] returns the latest event. This is the event for the current
    year, unless the current date is before December, in which case it is the
    event for the previous year. *)
val get_latest : unit -> t
