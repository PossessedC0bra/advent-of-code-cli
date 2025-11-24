module Infix = struct
  (** Infix operators for the [Result] module. *)

  open Stdlib.Result

  (** [let*] is an alias for [Result.bind]. It allows for monadic binding in a
      [let] expression. *)
  let ( let* ) = bind

  (** [>>=] is an alias for [Result.bind]. It is the standard monadic binding
      operator. *)
  let ( >>= ) = bind

  (** [>>|] is an alias for [Result.map]. It is the standard monadic mapping
      operator. *)
  let ( >>| ) x f = map f x

  (** [>>!] is an alias for [Result.map_error]. It is a monadic mapping
      operator for the error case. *)
  let ( >>! ) x f = map_error f x
end
