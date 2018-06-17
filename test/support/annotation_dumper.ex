defmodule AwsExRay.HTTPoison.AnnotationCreator.Dumper do

  @behaviour AwsExRay.HTTPoison.AnnotationCreator.Behaviour
  alias AwsExRay.Util

  @impl AwsExRay.HTTPoison.AnnotationCreator.Behaviour
  def create(req, {:ok, _resp}) do
    %{
      my_annotation_url: req.url,
      my_annotation_trace: Util.get_header(req.headers, "x-amzn-trace-id"),
      my_annotation_success: true
    }
  end
  def create(req, {:error, _error}) do
    %{
      my_annotation_url: req.url,
      my_annotation_trace: Util.get_header(req.headers, "x-amzn-trace-id"),
      my_annotation_success: false
    }
  end

end
