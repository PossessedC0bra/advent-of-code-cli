open Cmdliner

let init session_cookie = print_endline ("Session cookie: " ^ session_cookie)
let cmd = Cmd.v (Cmd.info "init") Term.(const init $ Arguments.session_cookie_arg)
