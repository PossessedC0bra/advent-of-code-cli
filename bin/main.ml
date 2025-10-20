open Cmdliner

let session_cookie_arg =
  let doc = "The session cookie for accessing the Advent of Code Website and API" in
  Arg.(
    required
    & opt (some string) None
    & info
        ~env:(Cmd.Env.info "ADVENT_OF_CODE_SESSION_COOKIE")
        ~docv:"SESSION_COOKIE"
        ~doc
        [ "s"; "session-cookie" ]
  )
;;

module AdventOfCode = struct
  module Event = struct
    let publish_time_zone_offset_s = -5 * 60 * 60

    module Year : sig
      type t

      val create : int -> (t, string) result
      val int_value : t -> int
      val get_latest : t
    end = struct
      type t = int

      let get_latest =
        let open Ptime in
        let open Ptime_clock in
        let now = now () in
        let current_year = to_year now in
        let current_year_event_start =
          Ptime.of_date ~tz_offset_s:publish_time_zone_offset_s (current_year, 12, 1)
          |> Option.get
        in
        match is_earlier now ~than:current_year_event_start with
        | true -> current_year - 1
        | false -> current_year
      ;;

      let create year =
        let latest_event = get_latest in
        if year < 2015
        then
          Error
            (Printf.sprintf
               "❌ Invalid year: %d\n\n\
                Advent of Code didn't exist yet in %d!\n\
                The first event was held in 2015.\n\n\
                💡 Try a year from 2015 onwards."
               year
               year
            )
        else if year > latest_event
        then
          Error
            (Printf.sprintf
               "❌ Event not available: %d\n\n\
                The Advent of Code %d event hasn't started yet.\n\
                Events begin on December 1st at midnight EST (UTC-5).\n\n\
                📅 Latest available year: %d"
               year
               year
               latest_event
            )
        else Ok year
      ;;

      let int_value t = t
    end
  end

  module Api = struct
    let download_input token year day =
      let url = Printf.sprintf "https://adventofcode.com/%d/day/%d/input" year day in
      let headers =
        [ ("Cookie", Printf.sprintf "session=%s" token); ("Accept", "text/plain") ]
      in
      Ezcurl.get ~url ~headers ()
    ;;

    let post_answer token year day level answer =
      let url = Printf.sprintf "https://adventofcode.com/%d/day/%d/answer" year day in
      let headers =
        [
          ("Cookie", Printf.sprintf "session=%s" token)
        ; ("Content-Type", "application/x-www-form-urlencoded")
        ]
      in
      ()
    ;;
  end
end

module AdventOfCodeCli = struct
  module Arguments = struct
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
                   |> AdventOfCode.Event.Year.create
                   |> Result.map_error (fun err -> `Msg err)
                 )
               , fun f y -> AdventOfCode.Event.Year.int_value y |> Format.pp_open_box f
               )
            )
            AdventOfCode.Event.Year.get_latest
            (info ~doc ~docv:"YYYY" [ "y"; "year" ])
      )
    ;;

    let day =
      let doc = "The day of the puzzle (1-25)" in
      Arg.(required & pos 0 (some int) None & info ~doc ~docv:"DAY" [])
    ;;
  end

  module Commands = struct
    module Init = struct
      let init session_cookie = print_endline ("Session cookie: " ^ session_cookie)
      let cmd = Cmd.v (Cmd.info "init") Term.(const init $ session_cookie_arg)
    end

    module DownloadInput = struct
      let action token year day =
        match
          AdventOfCode.Api.download_input
            token
            (AdventOfCode.Event.Year.int_value year)
            day
        with
        | Ok response ->
          ( match response.code with
            | x when x >= 200 && x <= 299 ->
              print_string (Ezcurl.string_of_response response);
              `Ok ()
            | x when x >= 400 && x <= 500 ->
              prerr_endline (Ezcurl.string_of_response response);
              `Error (false, "Error ")
            | _ -> `Error (true, "Unknown Error")
          )
        | Error (_, s) -> `Error (false, s)
      ;;

      let cmd =
        Cmd.v
          (Cmd.info "download-input")
          Term.(ret (const action $ session_cookie_arg $ Arguments.year $ Arguments.day))
      ;;
    end

    let cmds = [ Init.cmd; DownloadInput.cmd ]
  end

  let command = Cmd.group (Cmd.info "aoc-cli" ~version:"0.1.0") Commands.cmds
end

let () =
  Dotenv.export ();
  exit (Cmd.eval AdventOfCodeCli.command)
;;
