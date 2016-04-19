defmodule RemarkApi.Http.Handlers.Api.V1.Login do
  use RemarkApi.Http.Concerns.JsonApiHandler

  defp process({"POST", "application/json"}, req, state) do
    hash = fetch_json_request_body(req)
    reply = make_ok_json_response(req, %{})
    {:ok, reply, state}
  end
end
