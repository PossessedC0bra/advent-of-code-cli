open Cmdliner

let session_cookie_arg =
  let doc = "The $(docv) for accessing the Advent of Code API / Website." in
  Arg.(
    required
    & opt (some string) None
    & info
        ~env:(Cmd.Env.info "ADVENT_OF_CODE_SESSION_COOKIE" ~doc)
        ~docv:"COOKIE"
        ~doc:
          (doc ^ " Will be read from the environment variable '$(env)' if not specified.")
        [ "s"; "session-cookie" ]
  )
;;

let year =
  let doc =
    "Target the event that was held in $(docv). Defaults to the last active event."
  in
  let converter =
    let parser =
      fun s ->
      let open Commons.Option.Infix in
      s
      |> int_of_string_opt
      >>| Advent_of_code.Event.create
      |> function
      | Some year -> year
      | None -> Error (Printf.sprintf "❌ Invalid year: %s — not a number." s)
    in
    let printer = fun f y -> y |> Advent_of_code.Event.year |> Format.pp_print_int f in
    Arg.conv' (parser, printer)
  in
  Arg.(
    value
    & opt converter (Advent_of_code.Event.get_latest ())
    & info ~doc ~docv:"YEAR" [ "y"; "year" ]
  )
;;

let day =
  let doc =
    "Target the puzzle that was released on the n-th $(docv) of an event. Defaults to \
     the currently active puzzle day if there is an ongoing Advent of Code event."
  in
  let current_puzzle_day_opt =
    let open Commons.Option.Infix in
    Advent_of_code.(Puzzle.get_current () >>| Puzzle.day)
  in
  Arg.(
    required
    & opt (some int) current_puzzle_day_opt
    & info ~doc ~docv:"DAY" [ "d"; "day" ]
  )
;;

let output =
  let doc = "The $(docv) to write to. Use '-' to write to STDOUT. Defaults to STDOUT." in
  let converter =
    let parser = function
      | "" | "-" -> Ok None
      | s ->
        let prompt_overwrite filename =
          Printf.printf "⚠️  File '%s' already exists. \n\nOverwrite? (y/N): " filename;
          let res =
            try read_line () with
            | _ -> "n"
          in
          String.lowercase_ascii res = "y"
        in
        if Sys.file_exists s && not (prompt_overwrite s)
        then Error (Printf.sprintf "⚠️  Cancelled: File '%s' was not overwritten" s)
        else Ok (Some s)
    in
    let printer =
      fun f -> function
        | None -> Format.fprintf f "STDOUT"
        | Some s -> Format.fprintf f "%s" s
    in
    Arg.conv' (parser, printer)
  in
  Arg.(value & opt converter None & info ~doc ~docv:"FILE" [ "o"; "output" ])
;;
