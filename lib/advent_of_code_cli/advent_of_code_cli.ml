open Cmdliner

let version =
  match Build_info.V1.version () with
  | None -> "n/a"
  | Some v -> Build_info.V1.Version.to_string v
;;

let commands = [ Commands.Download_input.cmd ]
let command = Cmd.group (Cmd.info "aoc-cli" ~version) commands
let run () = exit (Cmd.eval command)
