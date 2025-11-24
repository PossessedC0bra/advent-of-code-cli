type t = int

let publish_time_zone_offset_s = -5 * 60 * 60

let create = function
  | year when year < 2015 ->
    Error (Printf.sprintf "❌ Invalid year: %d — Advent of Code started in 2015." year)
  | year -> Ok year
;;

let get_latest () =
  let open Ptime in
  let open Ptime_clock in
  let now = now () in
  let current_year = to_year now in
  let current_year_event_start =
    of_date ~tz_offset_s:publish_time_zone_offset_s (current_year, 12, 1)
    |> Option.value
         ~default:
           (failwith
              (Printf.sprintf
                 "Failed to create start date of this years Advent of Code event: \
                  %d-12-01"
                 current_year
              )
           )
  in
  if is_earlier now ~than:current_year_event_start then current_year - 1 else current_year
;;

let year event = event
