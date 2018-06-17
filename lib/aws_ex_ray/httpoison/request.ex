defmodule AwsExRay.HTTPoison.Request do

  @type t :: %__MODULE__{
    method:  atom,
    url:     binary,
    body:    any,
    headers: HTTPoison.Base.headers,
    options: Keyword.t
  }

  defstruct method:  "",
            url:     "",
            body:    "",
            headers: [],
            options: []

end

