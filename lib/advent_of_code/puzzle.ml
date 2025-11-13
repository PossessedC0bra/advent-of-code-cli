type t = Event.t * int

let create ~event ~day =
  let year = Event.year event in
  let max_puzzles = if year >= 2025 then 12 else 25 in
  if day < 1 || day > max_puzzles
  then (
    match year with
    | _ when year >= 2025 ->
      Error
        (Printf.sprintf
           "❌ Invalid day: %d — Starting from 2025, there are 12 instead of 25 puzzles \
            available."
           day
        )
    | _ -> Error (Printf.sprintf "❌ Invalid day: %d — must be between 1 and 25." day)
  )
  else Ok (event, day)
;;

let of_year_and_day year day =
  let open Commons.Result.Infix in
  let* event = Event.create year in
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
