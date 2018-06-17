defmodule AwsExRay.HTTPoison.AnnotationCreator.Nothing do

  @behaviour AwsExRay.HTTPoison.AnnotationCreator.Behaviour

  @impl AwsExRay.HTTPoison.AnnotationCreator.Behaviour
  def create(_req, _res) do
    %{}
  end

end
