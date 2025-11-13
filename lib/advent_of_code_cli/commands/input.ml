open Cmdliner
open Ezcurl

let action token year day output_file =
  let puzzle = Advent_of_code.Puzzle.create ~event:year ~day in
  match puzzle with
  | Ok p ->
    ( match Advent_of_code.Client.download_input token p with
      | Ok response ->
        ( match response.code with
          | x when x >= 200 && x <= 299 ->
            ( match output_file with
              | None ->
                print_string response.body;
                `Ok ()
              | Some filename ->
                let oc = open_out filename in
                Fun.protect
                  (fun () ->
                     output_string oc response.body;
                     close_out oc;
                     Printf.printf "✅ Input saved to %s\n" filename;
                     `Ok ()
                   )
                  ~finally:(fun () -> close_out_noerr oc)
            )
          | code -> `Error (true, Printf.sprintf "HTTP Error %d: %s" code response.body)
        )
      | Error (_, s) -> `Error (false, s)
    )
  | Error s -> `Error (true, s)
;;

let cmd =
  Cmd.(
    v
      (info
         "input"
         ~doc:
           "Download your Advent of Code puzzle input for a given day and year. \
            Optionally save to a file."
      )
      Term.(
        ret
          (const action
           $ Arguments.session_cookie_arg
           $ Arguments.year
           $ Arguments.day
           $ Arguments.output
          )
      )
  )
;;
