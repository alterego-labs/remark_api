defmodule RemarkApi.Http.Concerns.JsonApiHandler do
  @moduledoc """
  Contains common logic to create JSON API handlers.

  This concern hide from us several bunch of methods:
    - callbacks that each cowboy handler must has.
    - custom processing flow which depends on allowed HTTP methods and content type
    - helper function to generate final API response
    - helper function to fetch bindings: URL parameters
    - helper function to fetch request JSON body
    - helper function to fetch query parameters
    - helper function to fetch pagination information
    - implicitly provides OPTIONS request handling for CORS supporting

  ## Example of basic usage
    
  ```elixir
  defmodule MyCoolHandler do
    use RemarkApi.Http.Concerns.JsonApiHandler

    defp process({"GET", "application/json"}, req, state) do
      some_response_hash = %{data: "value"}
      reply = make_ok_json_response(req, some_response_hash)
      {:ok, reply, state}
    end
  end
  ```
  """

  defmacro __using__(_opts \\ []) do
    quote do
      @response_headers [
        {"access-control-allow-origin", "*"},
        {"access-control-allow-methods", "GET, POST, PUT, OPTIONS"},
        {"Access-Control-Allow-Headers", "origin, content-type, authorization"},
        {"content-type", "application/json"}
      ]

      def init(_type, req, []) do
        {:ok, req, :no_state}
      end

      def handle(req, state) do
        {method, req2} = :cowboy_req.method(req)
        {content_type, req3} = :cowboy_req.header("content-type", req2)
        normal_content_type = content_type_normalization(content_type)
        process({method, normal_content_type}, req3, state)
      end

      def terminate(reason, request, state) do
        :ok
      end

      @doc """
      Fetches bindings values or URL parameters.
      For example, if you have URL pattern `/users/:login` and you request URL `/users/sergio` then
      in bindings you will have keyword with key `login` and value `sergio`.
      By passing _key_ you fetches value of that entry which you need.
      """
      defp fetch_binding(req, key) do
        {bindings, _req2} = :cowboy_req.bindings(req)
        Keyword.get(bindings, key)
      end

      @doc """
      Fetches body from request and decode it to JSON format.
      """
      defp fetch_json_request_body(req) do
        {:ok, body, _req2} = :cowboy_req.body(req)
        {:ok, hash} = JSX.decode(body)
        hash
      end

      @doc """
      Fetches query parameters.
      For example, if someone requests URL `/messages?per_page=10` then you can fetch _per\_page_
      value by passing proper _key_ as second parameter.
      """
      defp fetch_qs_val(req, key) do
        {value, _req2} = :cowboy_req.qs_val(key, req)
        value
      end

      @doc """
      Fetches and builds pagination information.
      """
      defp fetch_pagination(req) do
        last_message_id = fetch_qs_val(req, "last_message_id")
        per_page = fetch_qs_val(req, "per_page")
        RemarkApi.Pagination.build(last_message_id, per_page)
      end

      defp content_type_normalization(:undefined), do: ""
      defp content_type_normalization(value) do
        value |> String.split(";") |> Enum.at(0)
      end

      import RemarkApi.Http.Concerns.Authorization

      @before_compile RemarkApi.Http.Concerns.JsonApiHandler
    end
  end

  @doc false
  defmacro __before_compile__(_env) do
    quote do
      @doc """
      Processing requests by pattern matching which is depends on http method and content type.

      By default several clauses already exists to handle some common behaviour:
      - handle _OPTIONS_ request
      - provide appropriate response for request with not allowed method
      - provide appropriate response for request with not allowed content type
      """
      @spec process({String.t, String.t}, any, any) :: {:ok, any, any}
      defp process({"OPTIONS", _}, req, state) do
        reply = build_reply(req, 200)
        {:ok, reply, state}
      end
      defp process({_, "application/json"}, req, state) do
        reply = build_reply(req, 406)
        {:ok, reply, state}
      end
      defp process({_, _}, req, state) do
        reply = build_reply(req, 415)
        {:ok, reply, state}
      end

      defp make_ok_json_response(req, hash), do: build_json_response(req, hash, 200)

      defp make_not_found_json_response(req, hash), do: build_json_response(req, hash, 404)

      defp make_422_json_response(req, hash), do: build_json_response(req, hash, 422)

      defp make_bad_request_json_response(req, hash), do: build_json_response(req, hash, 400)

      defp make_unauthorized_json_response(req, hash), do: build_json_response(req,hash, 401)

      defp build_json_response(req, hash, status) do
        {:ok, json} = JSX.encode(%{data: hash})
        build_reply(req, status, json)
      end

      defp build_reply(req, http_status, json \\ "") do
        {:ok, reply} = :cowboy_req.reply(http_status, @response_headers, json, req)
        reply
      end
    end
  end
end
