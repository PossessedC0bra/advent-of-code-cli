module Infix = struct
  open Stdlib.Option

  let ( let* ) = bind
  let ( >>= ) = bind
  let ( >>| ) f x = map x f
end
