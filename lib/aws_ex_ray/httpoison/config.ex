defmodule AwsExRay.HTTPoison.Config do

  alias AwsExRay.HTTPoison.TracedOptionRule
  alias AwsExRay.HTTPoison.AnnotationCreator

  @default_traced_option_rule TracedOptionRule.LeftMatch
  @default_annotation_creator AnnotationCreator.Nothing

  @spec get(atom, any) :: any
  def get(key, default) do
    Application.get_env(:aws_ex_ray, :httpoison, [])
    |> Keyword.get(key, default)
  end

  def traced_option_rule() do
    get(:traced_option_rule, @default_traced_option_rule)
  end

  def annotation_creator() do
    get(:annotation_creator, @default_annotation_creator)
  end

end
