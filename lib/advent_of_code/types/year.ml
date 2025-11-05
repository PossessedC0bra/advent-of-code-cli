type t = int

let latest () =
  let open Ptime in
  let open Ptime_clock in
  let now = now () in
  let current_year = to_year now in
  let current_year_event_start =
    Ptime.of_date ~tz_offset_s:Event.publish_time_zone_offset_s (current_year, 12, 1)
    |> Option.get
  in
  if is_earlier now ~than:current_year_event_start then current_year - 1 else current_year
;;

let of_int year =
  let latest_event = latest () in
  if year < 2015
  then
    Error
      (Printf.sprintf
         "❌ Invalid year: %d — Advent of Code didn't exist yet in %d!"
         year
         year
      )
  else if year > latest_event
  then
    Error
      (Printf.sprintf
         "❌ Event not available: %d — Latest available year is %d."
         year
         latest_event
      )
  else Ok year
;;

let int_value year = year
