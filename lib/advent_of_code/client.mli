val download_input
  :  string
  -> Puzzle.t
  -> (Ezcurl_core.response, Curl.curlCode * string) result
