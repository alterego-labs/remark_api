defmodule RemarkApi.Http.Handlers.Index do
  def init(_type, req, []) do
    {:ok, req, :no_state}
  end

  def handle(request, state) do
    {:ok, reply} = :cowboy_req.reply(
      200,
      [],
      "<html><body><h1>Hello!</h1></body></html>",
      request
    )
    {:ok, reply, state}
  end

  def terminate(reason, request, state) do
    :ok
  end
end
