let () =
  Dotenv.export ();
  Dotenv.export ~path:"~/.config/aoc-cli/.env" ();
  Advent_of_code_cli.run ()
;;
