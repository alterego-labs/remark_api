defmodule RemarkApi.Http.Handlers.Api.V1.Messages do
  def init(_type, req, []) do
    {:ok, req, :no_state}
  end

  def handle(req, state) do
    {method, req2} = :cowboy_req.method(req)
    {content_type, req3} = :cowboy_req.header("content-type", req2)
    process({method, content_type}, req3, state)
  end

  def terminate(reason, request, state) do
    :ok
  end

  defp process({"GET", "application/json"}, req, state) do
    {:ok, reply} = :cowboy_req.reply(200, [], "{\"rest\": \"Hello World!\"}", req)
    {:ok, reply, state}
  end

  defp process({"POST", "application/json"}, req, state) do
    {:ok, reply} = :cowboy_req.reply(200, [], "{\"rest\": \"Hello World!\"}", req)
    {:ok, reply, state}
  end

  defp process({_, "application/json"}, req, state) do
    {:ok, reply} = :cowboy_req.reply(406, [], "", req)
    {:ok, reply, state}
  end

  defp process({_, _}, req, state) do
    {:ok, reply} = :cowboy_req.reply(415, [], "", req)
    {:ok, reply, state}
  end
end
