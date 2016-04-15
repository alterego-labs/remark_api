defmodule RemarkApi.Http.Point do
  use GenServer

  alias RemarkApi.Http.Handlers

  def start_link(opts \\ []) do
    dispatch = :cowboy_router.compile([
      {:_, [
          {"/", Handlers.Index, []},
          {"/api/v1/messages", Handlers.Api.V1.Messages, []},
          {"/api/v1/users/:login", Handlers.Api.V1.User, []}
        ]},
    ])
    :cowboy.start_http :remark_api, 100, [port: 8183], [env: [dispatch: dispatch]]
  end
end
