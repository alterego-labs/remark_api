defmodule RemarkApi.Http.Point do
  use GenServer

  alias RemarkApi.Http.Handlers

  def start_link(opts \\ []) do
    dispatch = :cowboy_router.compile([
      {:_, [
          {"/", Handlers.Index, []},
          {"/ws", Handlers.WsHandler, []},
          {"/api/v1/login", Handlers.Api.V1.Login, []},
          {"/api/v1/messages", Handlers.Api.V1.Messages, []},
          {"/api/v1/users/:login", Handlers.Api.V1.User, []},
          {"/api/v1/users/:login/token", Handlers.Api.V1.UserToken, []},
          {"/api/v1/users/:login/messages", Handlers.Api.V1.UserMessages, []},
          {"/api/v2/login", Handlers.Api.V1.Login, []},
          {"/api/v2/register", Handlers.Api.V2.Register, []}
        ]},
    ])
    point_config = Application.get_env(:remark_api, __MODULE__)
    port = Keyword.get(point_config, :port)
    :cowboy.start_http :remark_api, 100, [port: port], [env: [dispatch: dispatch]]
  end
end
