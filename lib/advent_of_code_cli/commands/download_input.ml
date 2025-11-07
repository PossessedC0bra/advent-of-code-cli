open Cmdliner
open Ezcurl

let action token year day output_file =
  match
    Advent_of_code.Client.download_input
      token
      (year |> Advent_of_code.Types.Year.int_value)
      (day |> Advent_of_code.Types.Day.int_value)
  with
  | Ok response ->
    ( match response.code with
      | x when x >= 200 && x <= 299 ->
        ( match output_file with
          | None ->
            print_string response.body;
            `Ok ()
          | Some filename ->
            let oc = open_out filename in
            output_string oc response.body;
            close_out oc;
            Printf.printf "✅ Input saved to %s\n" filename;
            `Ok ()
        )
      | _ -> `Error (true, "HTTP error")
    )
  | Error (_, s) -> `Error (false, s)
;;

let cmd =
  Cmd.v
    (Cmd.info "download-input")
    Term.(
      ret
        (const action
         $ Arguments.session_cookie_arg
         $ Arguments.year
         $ Arguments.day
         $ Arguments.output
        )
    )
;;
