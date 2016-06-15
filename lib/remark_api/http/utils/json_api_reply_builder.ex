defmodule RemarkApi.Http.Utils.JsonApiReplyBuilder do
  @moduledoc """
  Provides a bunch of methods for building different kinds of replies.

  ## Usage

  Import functions from this module in the context, where you want to make replies:

  ```elixir
  defmodule MyHandler do
    import RemarkApi.Http.Concerns.JsonApiReplyBuilder
    ...
  end
  ```

  And in this module you can use all of the provided methods.
  """

  @response_headers [
    {"access-control-allow-origin", "*"},
    {"access-control-allow-methods", "GET, POST, PUT, OPTIONS"},
    {"Access-Control-Allow-Headers", "origin, content-type, authorization"},
    {"content-type", "application/json"}
  ]

  @doc """
  Makes 200 OK reply
  """
  def make_ok_reply(req, hash), do: build_json_response(req, hash, 200)

  @doc """
  Makes 400 Bad Request reply
  """
  def make_bad_request_reply(req, hash), do: build_json_response(req, hash, 400)

  @doc """
  Makes 401 Unauthorized reply
  """
  def make_unauhtorized_reply(req, hash), do: build_json_response(req, hash, 401)

  @doc """
  Makes 404 Not Found reply
  """
  def make_not_found_reply(req, hash), do: build_json_response(req, hash, 404)

  @doc """
  Makes 405 Method Not Allowed reply
  """
  def make_method_not_allowed_reply(req, hash), do: build_json_response(req, hash, 405)

  @doc """
  Makes 406 Not Acceptable reply
  """
  def make_not_acceptable_reply(req, hash), do: build_json_response(req, hash, 406)

  @doc """
  Makes 422 Unprocessable Entity reply
  """
  def make_unprocessable_entity_reply(req, hash), do: build_json_response(req, hash, 422)

  defp build_json_response(req, hash, status) do
    {:ok, json} = JSX.encode(%{data: hash})
    build_reply(req, status, json)
  end

  defp build_reply(req, http_status, json \\ "") do
    {:ok, reply} = :cowboy_req.reply(http_status, @response_headers, json, req)
    reply
  end
end
