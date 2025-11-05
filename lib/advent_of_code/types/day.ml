type t = int

let of_int day =
  if day < 1 || day > 25
  then Error (Printf.sprintf "❌ Invalid day: %d — Day must be between 1 and 25." day)
  else Ok day
;;
