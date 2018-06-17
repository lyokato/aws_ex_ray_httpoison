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

  Or if you don't like to add options argument for it,
  You can take another way.

  Set configuration like following

  ```elixir
  config :aws_ex_ray, :httpoison,
    traced_destinations: [
      "http://microservice.example.org/",
      "http://onemore.exampl.org/v1"
    ]
  ```

  Your request-url string starts with one of them, it'll automatically
  put **X-Amzn-Trace-Id** header.

  ## Annotation Injection

  In many case, you want to put more detailed annotations
  related to its HTTP Request/Response.

  You can set your own **AnnotationCreator**

  ```elixir
  config :aws_ex_ray, :httpoison,
    traced_destinations: ...
    annotation_creator: MyAnnotationCreatorModule
  ```

  The moduel should implements `AwsExRay.HTTPoison.AnnotationCreator` behaviour.

  ```example

  defmodule MyAnnotationCreator do

    @behaviour AwsExRay.HTTPoison.AnnotationCreator.Behaviour
    alias AwsExRay.Util

    @impl AwsExRay.HTTPoison.AnnotationCreator.Behaviour
    def create(req, {:ok, _resp}) do

    # req: AwsExRay.HTTPoison.Request.t
    #
    #      The definition is
    #
    #          @type t :: %__MODULE__{
    #            method:  atom,
    #            url:     binary,
    #            body:    any,
    #            headers: HTTPoison.Base.headers,
    #            options: Keyword.t
    #          }
    #
    #
    # resp: HTTPoison.Response.t
    #

      %{
        my_annotation_url: req.url,
        my_annotation_success: true
      }
    end

    def create(req, {:error, _error}) do
    # error: HTTPoison.Error.t
      %{
        my_annotation_url: req.url,
        my_annotation_success: false
      }
    end

  end
  ```

  """
end
