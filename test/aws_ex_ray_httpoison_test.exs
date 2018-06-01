defmodule AwsExRayHttpoisonTest do

  use ExUnit.Case

  import Mox

  use StructAssert

  setup do
    AwsExRay.Test.Mox.setup_default()
    :ok
  end

  test "httpoison subsegment" do

    {:ok, agent} = Agent.start_link(fn -> [] end)

    AwsExRay.Client.Sandbox.Sink.Stub
    |> stub(:send, fn data ->

      Agent.update(agent, fn state -> [data|state] end)

    end)

    trace = AwsExRay.Trace.new()
    segment = AwsExRay.start_tracing(trace, "dummy_trace_name")

    _result = AwsExRay.HTTPoison.get! "http://httparrot.herokuapp.com/get"

    AwsExRay.finish_tracing(segment)

    [got1, got2] = Agent.get(agent, &(&1))

    seg = Poison.decode!(got1)
    sub = Poison.decode!(got2)

    assert_subset(seg, %{
      "annotations" => %{"foo" => "bar"},
      #"end_time" => 1527876197.54698,
      #"id" => "f49b33a912a94490",
      "metadata" => %{
        "bar" => "buz",
        "tracing_sdk" => %{"name" => "aws-ex-ray", "version" => "0.0.1"}
      },
      "name" => "dummy_trace_name",
      #"start_time" => 1527876197.139416,
      #"trace_id" => "1-5b118a65-894598852209c5d965d1513c"
    })

    assert_subset(sub, %{
      "annotations" => %{"foo" => "bar"},
      # "end_time" => 1527876325.399518,
      "http" => %{
        "request" => %{"method" => "GET", "traced" => false, "url" => "http://httparrot.herokuapp.com/get"},
        "response" => %{
          #"content_length" => 595,
          "status" => 200
        }
      },
      #"id" => "5cb6d087e438e82e",
      "metadata" => %{
        "bar" => "buz",
        "tracing_sdk" => %{"name" => "aws-ex-ray", "version" => "0.0.1"}
      },
      "name" => "httparrot.herokuapp.com",
      "namespace" => "remote",
      "parent_id" => seg["id"],
      #"start_time" => 1527876325.041149,
      #"trace_id" => "1-5b118ae5-0f3aa7b153a67e7b40a0c9d9",
      "type" => "subsegment"
    })

  end
end
