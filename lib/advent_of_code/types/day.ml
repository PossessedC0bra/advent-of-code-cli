type t = int

let of_int day =
  if day < 1 || day > 25
  then Error (Printf.sprintf "❌ Invalid day: %d — must be between 1 and 25." day)
  else Ok day
;;

let current () =
  let open Ptime in
  let open Ptime_clock in
  let now = now () in
  let _, m, d = to_date ~tz_offset_s:Event.publish_time_zone_offset_s now in
  if m == 12
  then (
    match of_int d with
    | Ok day -> Some day
    | Error _ -> None
  )
  else None
;;

let int_value day = day
