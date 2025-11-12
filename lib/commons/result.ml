module Infix = struct
  open Stdlib.Result

  let ( let* ) = bind
  let ( >>= ) = bind
  let ( >>+ ) x f = map f x
  let ( >>- ) x f = map_error f x
end
