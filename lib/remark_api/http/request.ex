defmodule RemarkApi.Http.Request do
  @moduledoc """
  Represents a struct which contains all information about request.

  Under the hood it is merely a wrapper around cowboy's request struct, but besides that this module
  provides some additional high-level functions to retrieve an apropriate chuck of information.
  """

  defstruct [:original_req]

  @type remark_api_request :: RemarkApi.Http.Request

  @doc """
  Fetches request header by its name.
  """
  @spec header(remark_api_request, String.t) :: String.t
  def header(request, name) do
    :cowboy_req.header(name, request.original_req)
  end

  @doc """
  Fetches bindings values or URL parameters.
  For example, if you have URL pattern `/users/:login` and you request URL `/users/sergio` then
  in bindings you will have keyword with key `login` and value `sergio`.
  By passing _key_ you fetches value of that entry which you need.
  """
  @spec binding(remark_api_request, String.t) :: String.t
  def binding(request, key) do
    {bindings, _req2} = :cowboy_req.bindings(request.original_req)
    Keyword.get(bindings, key)
  end

  @doc """
  Fetches body from request and decode it to JSON format.
  """
  @spec json_body(remark_api_request) :: map
  def json_body(request) do
    {:ok, body, _req2} = :cowboy_req.body(request.original_req)
    {:ok, hash} = JSX.decode(body)
    hash
  end

  @doc """
  Fetches query parameters.
  For example, if someone requests URL `/messages?per_page=10` then you can fetch _per\_page_
  value by passing proper _key_ as second parameter.
  """
  @spec qs_val(remark_api_request, String.t) :: String.t
  def qs_val(request, key) do
    {value, _req2} = :cowboy_req.qs_val(key, request.original_req)
    value
  end

  @doc """
  Fetches and builds pagination information.
  """
  @spec pagination(remark_api_request) :: RemarkApi.Pagination.t
  def pagination(request) do
    last_message_id = qs_val(request, "last_message_id")
    per_page = qs_val(request, "per_page")
    RemarkApi.Pagination.build(last_message_id, per_page)
  end
end
