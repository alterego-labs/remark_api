defmodule RemarkApi.Http.Handlers.Api.V1.User do
  use RemarkApi.Http.Concerns.JsonApiHandler

  defp process({"GET", "application/json"}, req, state) do
    {bindings, req2} = :cowboy_req.bindings(req)
    login = Keyword.get(bindings, :login)
    reply = RemarkApi.Http.Processors.Api.V1.User.get_info(login) |> resolve_reply(req)
    {:ok, reply, state}
  end

  defp resolve_reply({:ok, hash}, req) do
    make_ok_json_response(req, %{user: hash})
  end

  defp resolve_reply({:not_found, _}, req) do
    make_not_found_json_response(req, %{errors: ["User not found!"]})
  end
end
