(** [download_input session_cookie puzzle] downloads the input for the [puzzle].
    Uses [session_cookie] to authenticate against the Advent of Code website.*)
val download_input
  :  string
  -> Puzzle.t
  -> (Ezcurl_core.response, Curl.curlCode * string) result
