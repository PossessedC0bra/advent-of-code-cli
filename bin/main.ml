open Base
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

let init session_cookie = Stdlib.print_endline ("Session cookie: " ^ session_cookie)

let () =
  Dotenv.export ();
  let doc = "A CLI tool to interact with Advent of Code from the command line" in
  let info = Cmd.info "aoc-cli" ~version:"0.1.0" ~doc in
  Stdlib.exit (Cmd.eval (Cmd.v info Term.(const init $ session_cookie_arg)))
;;
