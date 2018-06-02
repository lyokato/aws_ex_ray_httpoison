# AwsExRay - HTTPoison Support

## NOT STABLE YET

Please wait version 1.0.0 released.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `aws_ex_ray_httpoison` to your list of dependencies in `mix.exs`:

```elixir
def application do
  [
    extra_applications: [
      :logger,
      :aws_ex_ray
      # ...
    ],
    mod {MyApp.Supervisor, []}
  ]
end

def deps do
  [
    {:aws_ex_ray, "~> 0.1.0"},
    {:aws_ex_ray_httpoison, "~> 0.1.0"},
    # ...
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/aws_ex_ray_httpoison](https://hexdocs.pm/aws_ex_ray_httpoison).

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

## SEE ALSO

- Core: https://github.com/lyokato/aws_ex_ray
- Ecto Support: https://github.com/lyokato/aws_ex_ray_ecto
- Plug Support: https://github.com/lyokato/aws_ex_ray_plug
- ExAws Support: https://github.com/lyokato/aws_ex_ray_ex_aws

