defmodule RemarkApi.Http.Concerns.JsonApiHandler do
  @moduledoc """
  Contains common logic to create JSON API handlers.

  This concern hide from us several bunch of methods:
    - callbacks that each cowboy handler must has.
    - custom processing flow which depends on allowed HTTP methods and content type
    - helper function to generate final API response
    - helper function to fetch bindings: URL parameters

  ## Examples
    
    defmodule MyCoolHandler do
      use RemarkApi.Http.Concerns.JsonApiHandler

      defp process({"GET", "application/json"}, req, state) do
        some_response_hash = %{data: "value"}
        reply = make_ok_json_response(req, some_response_hash)
        {:ok, reply, state}
      end
    end
  """

  defmacro __using__(_opts \\ []) do
    quote do
      @response_headers [
        {"access-control-allow-origin", "*"},
        {"access-control-allow-methods", "GET, POST, PUT"},
        {"content-type", "application/json"}
      ]

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

      defp fetch_binding(req, key) do
        {bindings, req2} = :cowboy_req.bindings(req)
        Keyword.get(bindings, key)
      end

      @before_compile RemarkApi.Http.Concerns.JsonApiHandler
    end
  end

  @doc false
  defmacro __before_compile__(_env) do
    quote do
      defp process({_, "application/json"}, req, state) do
        reply = build_reply(req, 406)
        {:ok, reply, state}
      end

      defp process({_, _}, req, state) do
        reply = build_reply(req, 415)
        {:ok, reply, state}
      end

      defp make_ok_json_response(req, hash) do
        build_json_response(req, hash, 200)
      end

      defp make_not_found_json_response(req, hash) do
        build_json_response(req, hash, 404)
      end

      defp build_json_response(req, hash, status) do
        {:ok, json} = JSEX.encode(%{data: hash})
        build_reply(req, status, json)
      end

      defp build_reply(req, http_status, json \\ "") do
        {:ok, reply} = :cowboy_req.reply(http_status, @response_headers, json, req)
        reply
      end
    end
  end
end
