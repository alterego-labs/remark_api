defmodule RemarkApi.Http.JsonApiHandler do
  @moduledoc """
  The main point in order to handler API requests.

  Provides the following steps before a specific handler comes in play:

  1. Builds request struct, which will be passed to the specific handlers
  2. Checks request's content type
  3. Implicitly handles OPTIONS request
  4. Implicitly does reply

  This module acts as generic cowboy request handler.

  ## Usage

  You can use this handler as single point to your specific handlers. For this add the next line
  into cowboy's router configuration:

  ```elixir
  defmodule RemarkApi.Http.Point do
    use GenServer

    def start_link(opts \\ []) do
      dispatch = :cowboy_router.compile([
        {:_, [
            {"/api/v1/login", RemarkApi.Http.JsonApiHandler, [specific_handler: RemarkApi.Http.Handlers.Api.V1.Login]},
          ]},
      ])
      point_config = Application.get_env(:remark_api, __MODULE__)
      port = Keyword.get(point_config, :port)
      :cowboy.start_http :remark_api, 100, [port: port], [env: [dispatch: dispatch]]
    end
  end
  ```

  Please, notice `specific_handler` option, which is passed as argument. Due to this module provides
  only basic logic to handle JSON API requests, your real business logic must be contained somewhere and
  must be called somehow. So here is a decision: when all needed information is fetched from the
  request and some basic checkes are passed, the specific handler will be called.
  """

  @doc """
  Initialization function.
  """
  def init(_type, req, opts) do
    specific_handler = Keyword.get(opts, :specific_handler)
    {:ok, req, %{specific_handler: specific_handler}}
  end

  @doc """
  Handles an incoming request.
  """
  def handle(req, state) do
  end

  @doc false
  def terminate(reason, request, state) do
    :ok
  end
end
