defmodule RemarkApi.Http.Handlers.Api.V1.Messages do
  use RemarkApi.Http.Concerns.JsonApiHandler

  defp process({"GET", "application/json"}, req, state) do
    messages_hash = RemarkApi.Http.Processors.Api.V1.Messages.get_messages
    reply = make_ok_json_response(req, %{messages: messages_hash})
    {:ok, reply, state}
  end

  defp process({"POST", "application/json"}, req, state) do
    {:ok, reply} = :cowboy_req.reply(200, [], "{\"rest\": \"Hello World!\"}", req)
    {:ok, reply, state}
  end
end
