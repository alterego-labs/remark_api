defmodule RemarkApi.Http.Concerns.Authorization do
  @moduledoc """
  """

  alias RemarkApi.Http.Utils

  @doc """
  
  """
  defmacro require_authorized(req, state, do: expression) do
    quote do
      unless check_authorization(unquote(req)) do
        unquote(expression)
      else
        reply = make_unauthorized_json_response(unquote(req), %{errors: ['You do not authorized!']})
        {:ok, reply, unquote(state)}
      end
    end
  end

  defmacro require_guest(req, state, do: expression) do
    quote do
      if check_authorization(unquote(req)) do
        reply = make_unauthorized_json_response(unquote(req), %{errors: ['You do not authorized!']})
        {:ok, reply, unquote(state)}
      else
        unquote(expression)
      end
    end
  end

  @doc """
  Checks authorization by reading JWT token from the Authorization header and then check it through
  the existed tokens.
  """
  @spec check_authorization(:cowboy_req.t) :: boolean
  def check_authorization(req) do
    {authorization_token, _req} = :cowboy_req.header("authorization", req)
    Utils.UserTokenService.verify_token(authorization_token)
  end
end
