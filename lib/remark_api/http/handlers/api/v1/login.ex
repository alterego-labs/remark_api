defmodule RemarkApi.Http.Handlers.Api.V1.Login do
  use RemarkApi.Http.Concerns.JsonApiHandler

  defp process({"POST", "application/json"}, req, state) do
    reply = req
            |> fetch_json_request_body
            |> RemarkApi.Http.Processors.Api.V1.Login.call
            |> resolve_reply(req)
    {:ok, reply, state}
  end

  defp resolve_reply({:ok, hash}, req) do
    make_ok_json_response(req, %{user: hash})
  end

  defp resolve_reply({:error, errors}, req) do
    make_422_json_response(req, %{errors: errors})
  end
end
