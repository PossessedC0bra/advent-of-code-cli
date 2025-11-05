open Cmdliner

let session_cookie_arg =
  let doc = "The session cookie for accessing the Advent of Code Website and API" in
  Arg.(
    required
    & opt (some string) None
    & info
        ~env:(Cmd.Env.info "ADVENT_OF_CODE_SESSION_COOKIE")
        ~docv:"COOKIE"
        ~doc
        [ "s"; "session-cookie" ]
  )
;;

let year =
  let doc =
    "The year of the event to download inputs from. Defaults to the currently active \
     event"
  in
  Arg.(
    value
    & opt
        (conv
           ( (fun s ->
               int_of_string s
               |> Advent_of_code.Types.Year.of_int
               |> Result.map_error (fun err -> `Msg err)
             )
           , fun f y -> Advent_of_code.Types.Year.int_value y |> Format.pp_open_box f
           )
        )
        (Advent_of_code.Types.Year.latest ())
        (info ~doc ~docv:"YYYY" [ "y"; "year" ])
  )
;;

let day =
  let doc = "The day of the puzzle (1 - 25)" in
  Arg.(required & pos 0 (some int) None & info ~doc ~docv:"DAY" [])
;;

let output_file =
  let doc = "The file to write the puzzle input to" in
  let prompt_overwrite filename =
    Printf.printf "⚠️  File '%s' already exists. Overwrite? [y/N] " filename;
    flush stdout;
    let response = read_line () in
    String.lowercase_ascii response = "y" || String.lowercase_ascii response = "yes"
  in
  let converter =
    Arg.conv
      ( (fun s ->
          if s = ""
          then Ok None
          else if Sys.file_exists s && not (prompt_overwrite s)
          then Error (`Msg (Printf.sprintf "Cancelled: File '%s' was not overwritten" s))
          else Ok (Some s)
        )
      , fun f -> function
          | None -> Format.fprintf f "<cancelled>"
          | Some s -> Format.fprintf f "%s" s
      )
  in
  Arg.(value & opt converter None & info ~doc ~docv:"FILE" [ "o"; "output" ])
;;
