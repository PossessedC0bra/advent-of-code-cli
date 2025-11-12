type t = Event.t * Day.t

let create ~event ~day =
  if Event.year event >= 2025 && Day.to_int day > 12
  then
    Error
      (Printf.sprintf
         "❌ Invalid day: %d — Starting from 2025, there are 12 instead of 25 puzzles \
          available."
         (Day.to_int day)
      )
  else Ok (event, day)
;;

let of_year_and_day year day =
  let open Commons.Result.Infix in
  let* event = Event.create year in
  let* day = Day.create day in
  create ~event ~day
;;

let get_current () =
  let open Ptime in
  let open Ptime_clock in
  let now = now () in
  let y, m, d = to_date ~tz_offset_s:Event.publish_time_zone_offset_s now in
  if m = 12
  then (
    match of_year_and_day y d with
    | Ok day -> Some day
    | Error _ -> None
  )
  else None
;;

let event (event, _) = event
let day (_, day) = day
