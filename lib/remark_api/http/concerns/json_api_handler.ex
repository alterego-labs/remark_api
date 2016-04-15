defmodule RemarkApi.Http.Concerns.JsonApiHandler do
  @moduledoc """
  Contains common logic to create JSON API handlers.

  This concern hide from us several bunch of methods:
    - callbacks that each cowboy handler must has.
    - custom processing flow which depends on allowed HTTP methods and content type
    - helper function to generate final API response

  ## Examples
    
    defmodule MyCoolHandler do
      use RemarkApi.Http.Concerns.JsonApiHandler

      defp process({"GET", "application/json"}, req, state) do
        some_response_hash = %{data: "value"}
        reply = make_json_response(req, some_response_hash)
        {:ok, reply, state}
      end
    end
  """
  defmacro __using__ do
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

    defp process({_, "application/json"}, req, state) do
      {:ok, reply} = :cowboy_req.reply(406, [], "", req)
      {:ok, reply, state}
    end

    defp process({_, _}, req, state) do
      {:ok, reply} = :cowboy_req.reply(415, [], "", req)
      {:ok, reply, state}
    end

    defp make_json_response(req, hash) do
      {:ok, json} = JSEX.encode(%{data: hash})
      {:ok, reply} = :cowboy_req.reply(200, [{"content-type", "application/json"}], json, req)
      reply
    end
  end
end
