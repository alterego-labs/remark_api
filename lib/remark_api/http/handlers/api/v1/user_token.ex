defmodule RemarkApi.Http.Handlers.Api.V1.UserToken do
  use RemarkApi.Http.Concerns.JsonApiHandler

  alias RemarkApi.Processors.Api

  defp process({"POST", "application/json"}, req, state) do
    login = fetch_binding(req, :login)
    body = fetch_json_request_body(req)
    reply = Api.V1.UserToken.attach(login, body) |> resolve_reply(req)
    {:ok, reply, state}
  end

  defp resolve_reply({:ok, _hash}, req) do
    make_ok_json_response(req, %{})
  end
  defp resolve_reply({:not_found, _hash}, req) do
    make_not_found_json_response(req, %{errors: ["User not found!"]})
  end
  defp resolve_reply({:error, errors}, req) do
    make_422_json_response(req, %{errors: errors})
  end
end
