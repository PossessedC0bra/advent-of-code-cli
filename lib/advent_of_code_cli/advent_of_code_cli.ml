open Cmdliner

let command =
  let command_name = "aoc-cli" in
  let version =
    match Build_info.V1.version () with
    | None -> "n/a"
    | Some v -> Build_info.V1.Version.to_string v
  in
  let doc = "Advent of Code command line interface" in
  let commands = [ Commands.Download_input.cmd ] in
  Cmd.group (Cmd.info command_name ~version ~doc) commands
;;

let run () = exit (Cmd.eval command)
