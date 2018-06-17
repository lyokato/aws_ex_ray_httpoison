defmodule AwsExRay.HTTPoison.Base do

  defmacro __using__(_opts) do

    quote do

      use HTTPoison.Base

      alias AwsExRay.Record.Error
      alias AwsExRay.Record.Error.Cause
      alias AwsExRay.Record.HTTPRequest
      alias AwsExRay.Record.HTTPResponse
      alias AwsExRay.Stacktrace
      alias AwsExRay.Subsegment
      alias AwsExRay.HTTPClientUtil
      alias AwsExRay.Util

      alias AwsExRay.HTTPoison.TracedOptionRule
      alias AwsExRay.HTTPoison.AnnotationCreator

      def request(method, url, body \\ "", headers \\ [], options \\ []) do

        case start_subsegment(headers, url) do

          {:error, :out_of_xray} ->

            super(method, url, body, headers, options)

          {:ok, subsegment} ->

            headers = HTTPoison.process_request_headers(headers)
            options = HTTPoison.process_request_options(options)

            request_record = %HTTPRequest{
              segment_type: :subsegment,
              method:       String.upcase(to_string(method)),
              url:          url,
              traced:       traced?(url, options),
              user_agent:   HTTPClientUtil.get_user_agent(headers)
            }

            subsegment =
              Subsegment.set_http_request(subsegment, request_record)

            headers = HTTPClientUtil.put_tracing_header(headers, subsegment)

            result = super(method, url, body, headers, options)

            subsegment = case result do

              {:ok, %HTTPoison.Response{status_code: code, headers: headers}} ->
                len = HTTPClientUtil.get_response_content_length(headers)
                res = HTTPResponse.new(code, len)
                subsegment = Subsegment.set_http_response(subsegment, res)
                if code >= 400 and code < 600 do
                  HTTPClientUtil.put_response_error(subsegment,
                                                    code,
                                                    Stacktrace.stacktrace())
                else
                  subsegment
                end

              {:error, %HTTPoison.Error{reason: reason}} ->
                cause = Cause.new(:http_response_error,
                                  "#{reason}",
                                  Stacktrace.stacktrace())
                error = %Error{
                  cause:    cause,
                  throttle: false,
                  error:    false,
                  fault:    true,
                  remote:   false,
                }
                Subsegment.set_error(subsegment, error)

            end

            req = %AwsExRay.HTTPoison.Request{
              method:  method,
              url:     url,
              body:    body,
              headers: headers,
              options: options
            }

            subsegment
            |> inject_annotations(req, result)
            |> AwsExRay.finish_subsegment()

            result

        end

      end

      defp inject_annotations(subsegment, req, res) do
        annotations = AnnotationCreator.create(req, res)
        Subsegment.add_annotations(subsegment, annotations)
      end

      defp traced?(url, options) do
        if TracedOptionRule.traced?(url) do
          true
        else
          case Keyword.get(options, :traced, false) do
            result when is_boolean(result) -> result
            _                              -> false
          end
        end
      end

      defp start_subsegment(headers, url) do
        HTTPClientUtil.find_tracing_name(headers, url)
        |> AwsExRay.start_subsegment(namespace: :remote)
      end

    end

  end

end
