defmodule AwsExRay.HTTPoison.TracedOptionRule do

  alias AwsExRay.HTTPoison.Config

  defmodule Behaviour do
    @callback traced?(url :: String.t) :: boolean
  end

  @spec traced?(url :: String.t) :: boolean
  def traced?(url) do
    Config.traced_option_rule.traced?(url)
  end

end

