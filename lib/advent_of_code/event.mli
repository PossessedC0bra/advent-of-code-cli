type t

val publish_time_zone_offset_s : int
val create : int -> (t, string) result
val year : t -> int
val get_latest : unit -> t
