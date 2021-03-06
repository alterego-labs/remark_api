defmodule RemarkApi.Http.Handlers.Api.V1.UserMessages do
  use RemarkApi.Http.Concerns.JsonApiHandler

  defp process({"GET", "application/json"}, req, state) do
    pagination = fetch_pagination(req)
    login = fetch_binding(req, :login)
    reply = RemarkApi.Http.Processors.Api.V1.UserMessages.get_all(login, pagination)
            |> resolve_reply(req)
    {:ok, reply, state}
  end

  defp process({"PUT", "application/json"}, req, state) do
    login = fetch_binding(req, :login)
    body = fetch_json_request_body(req)
    reply = RemarkApi.Http.Processors.Api.V1.UserMessages.put_new_for(login, body)
            |> resolve_reply(req)
    {:ok, reply, state}
  end

  defp resolve_reply({:ok, hash}, req) when is_list(hash) do
    make_ok_json_response(req, %{messages: hash})
  end
  defp resolve_reply({:ok, hash}, req) when is_map(hash) do
    make_ok_json_response(req, %{message: hash})
  end
  defp resolve_reply({:not_found, _}, req) do
    make_not_found_json_response(req, %{errors: ["User not found!"]})
  end
  defp resolve_reply({:error, errors}, req) do
    make_422_json_response(req, %{errors: errors})
  end
end
