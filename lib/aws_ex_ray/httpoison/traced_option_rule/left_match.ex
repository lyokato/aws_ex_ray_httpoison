defmodule AwsExRay.HTTPoison.TracedOptionRule.LeftMatch do

  @behaviour AwsExRay.HTTPoison.TracedOptionRule.Behaviour

  alias  AwsExRay.HTTPoison.Config

  @impl AwsExRay.HTTPoison.TracedOptionRule.Behaviour
  def traced?(url) do
    Config.get(:traced_destinations, [])
    |> Enum.any?(fn dest ->
      u = String.downcase(url)
      d = String.downcase(dest)
      String.starts_with?(u, d)
    end)
  end

end
