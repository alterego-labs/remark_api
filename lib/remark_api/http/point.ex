defmodule RemarkApi.Http.Point do
  use GenServer

  alias RemarkApi.Http.Handlers

  def start_link(opts \\ []) do
    dispatch = :cowboy_router.compile([
      {:_, [
          {"/", RemarkApi.Http.Handlers.Index, []},
        ]},
    ])
    :cowboy.start_http :remark_api, 100, [port: 8183], [env: [dispatch: dispatch]]
  end
end
