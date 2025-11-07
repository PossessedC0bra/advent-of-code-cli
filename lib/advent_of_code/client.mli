val download_input
  :  string
  -> Types.Year.t
  -> Types.Day.t
  -> (Ezcurl_core.response, Curl.curlCode * string) result
