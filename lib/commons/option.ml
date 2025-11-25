module Infix = struct
  (** Infix operators for the [Option] module. *)

  open Stdlib.Option

  (** [let*] is an alias for [Option.bind]. It allows for monadic binding in a
      [let] expression. *)
  let ( let* ) = bind

  (** [>>=] is an alias for [Option.bind]. It is the standard monadic binding
      operator. *)
  let ( >>= ) = bind

  (** [>>|] is an alias for [Option.map]. It is the standard monadic mapping
      operator. *)
  let ( >>| ) x f = map f x
end
