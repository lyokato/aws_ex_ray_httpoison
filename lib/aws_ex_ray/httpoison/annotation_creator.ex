defmodule AwsExRay.HTTPoison.AnnotationCreator do

    alias AwsExRay.HTTPoison.AnnotationCreator
    alias AwsExRay.HTTPoison.Config
    alias AwsExRay.HTTPoison.Request

  @type httpoison_result :: {:ok, HTTPoison.Response.t() | HTTPoison.AsyncResponse.t()}
                          | {:error, HTTPoison.Error.t()}

  defmodule Behaviour do
    alias AwsExRay.HTTPoison.Request
    alias AwsExRay.HTTPoison.AnnotationCreator
    @callback create(req :: Request.t, result :: AnnotationCreator.httpoison_result) :: map
  end

  @type create(
    req    :: Request.t,
    result :: AnnotationCreator.httpoison_result
  ) :: map
  def create(req, result) do
    Config.annotation_creator.create(req, result)
  end

end

