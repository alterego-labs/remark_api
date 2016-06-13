defmodule RemarkApi.Http.Concerns.Authorization do
  @moduledoc """
  Provides additional functional to be able to secure your HTTP handlers by checking if user
  signed in or not.
  
  Basically the two provided macroses do the party. Using one of them you can put requirement that
  that particular handler requires authorized user or guest user.
  
  ## Usage

  The usage integration is very simple - you need wrap the process's body with one of the proposed
  macroses, for example:

  ```elixir
  defp process({"POST", "application/json"}, req, state) do
    require_guest(req, state) do
      ...
      {:ok, reply, state}
    end
  end

  The code inside `require_guest` will be run if current user is guest.
  ```
  """

  alias RemarkApi.Http.Utils

  @doc """
  Puts the condition that current user is signed in.
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

  @doc """
  Puts the condition that current user is guest.
  """
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
