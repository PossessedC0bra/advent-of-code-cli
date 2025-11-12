let base_url = "https://adventofcode.com"
let url suffix = Printf.sprintf "%s%s" base_url suffix
let session_cookie_header token = ("Cookie", Printf.sprintf "session=%s" token)

let download_input token puzzle =
  let url =
    url
      (Printf.sprintf
         "/%d/day/%d/input"
         (puzzle |> Puzzle.event |> Event.year)
         (puzzle |> Puzzle.day |> Day.to_int)
      )
  in
  let headers = [ session_cookie_header token; ("Accept", "text/plain") ] in
  Ezcurl.get ~url ~headers ()
;;
