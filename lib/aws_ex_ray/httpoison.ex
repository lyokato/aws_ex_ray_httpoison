defmodule AwsExRay.HTTPoison do
  use AwsExRay.HTTPoison.Base

  @moduledoc ~S"""
  ## USAGE

  Just use `AwsExRay.HTTPoison` instead of `HTTPoison`.

  ```elixir
  resp = AwsExRay.HTTPoison.get("https://example.org/", headers, options)
  ```

  Then automatically record subsegment if HTTP request called on the tracing process.


  If the destination(in following example, "https://microservice.example.org/api") supports
  X-Ray tracing, adss :traced option.

  Then it'll automatically set **X-Amzn-Trace-Id** header.

  ```elixir
  resp = AwsExRay.HTTPoison.get("https://microservice.example.org/api", headers, [traced: true])
  ```
  """
end
