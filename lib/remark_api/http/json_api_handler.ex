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

  import RemarkApi.Http.Concerns.JsonApiReplyBuilder

  alias RemarkApi.Http.Request

  require IEx

  @allowed_content_types ["application/json"]
  @specific_handler_key :specific_handler

  @doc """
  Initialization function.
  """
  def init(_type, req, opts) do
    specific_handler = Keyword.get(opts, @specific_handler_key)
    {:ok, req, %{@specific_handler_key => specific_handler}}
  end

  @doc """
  Handles an incoming request.
  """
  def handle(req, state) do
    req
    |> build_remark_api_request
    |> process(state)
  end

  @doc false
  def terminate(reason, request, state) do
    :ok
  end

  defp build_remark_api_request(req) do
    %RemarkApi.Http.Request{original_req: req}
  end

  defp process(remark_api_request, state) do
    reply = Request.header(remark_api_request, "content-type")
            |> check_content_type_allowance
            |> process_by_content_type(remark_api_request, state)
    {:ok, reply, state}
  end

  defp check_content_type_allowance(:undefined), do: false
  defp check_content_type_allowance(nil), do: false
  defp check_content_type_allowance(content_type) do
    @allowed_content_types
    |> Enum.any?(fn(allowed) -> String.contains?(content_type, allowed) end)
  end

  defp process_by_content_type(false = _allowed, %Request{original_req: original_req}, _state) do
    make_method_not_allowed_reply(original_req, %{})
  end
  defp process_by_content_type(true = _allowed, remark_api_request, state) do
    Request.method(remark_api_request)
    |> process_by_method(remark_api_request, state)
  end

  defp process_by_method("OPTIONS", %Request{original_req: original_req}, _state) do
    make_ok_reply(original_req, %{})
  end
  defp process_by_method(method, remark_api_request, state) do
    Map.get(state, @specific_handler_key)
    |> apply(:process, [method, remark_api_request])
    |> process_by_specific_handler_response(remark_api_request)
  end

  defp process_by_specific_handler_response(response, %Request{original_req: original_req}) do
    make_ok_reply(original_req, %{})
  end
end
