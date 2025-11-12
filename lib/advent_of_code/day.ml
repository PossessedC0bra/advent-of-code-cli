type t = int

let create day =
  if day < 1 || day > 25
  then Error (Printf.sprintf "❌ Invalid day: %d — must be between 1 and 25." day)
  else Ok day
;;

let to_int day = day
