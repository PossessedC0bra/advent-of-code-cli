module Infix = struct
  open Stdlib.Option

  let ( let* ) = bind
  let ( >>= ) = bind
  let ( >>| ) x f = map f x
end
