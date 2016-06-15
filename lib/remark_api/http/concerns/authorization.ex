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
  alias RemarkApi.Http.Request

  @doc """
  Puts the condition that current user is signed in.

  ## Usage

  ```elixir
  defp process(...) do
    require_authorized(req, state) do
      # Your handler code must be here
    end
  end
  ```

  Block inside `require_authorized` will be performed only if request is authorized. Request is authorized means
  that there is header *Authorization* with JWT token and it is valid.
  """
  defmacro require_authorized(remark_api_request, do: expression) do
    quote do
      unless check_authorization(unquote(remark_api_request)) do
        unquote(expression)
      else
        make_unauthorized_response(%{errors: ['You do not authorized!']})
      end
    end
  end

  @doc """
  Puts the condition that current user is guest.

  ## Usage

  ```elixir
  defp process(...) do
    require_guest(req, state) do
      # Your handler code must be here
    end
  end
  ```

  Block inside `require_guest` will be performed only if request is not authorized.
  Request is not authorized means:

  1. Request header *Authorization* does not exist. 
  2. Request header *Authorization* exists but token from it is invalid.
  """
  defmacro require_guest(remark_api_request, do: expression) do
    quote do
      if check_authorization(unquote(remark_api_request)) do
        make_unauthorized_response(%{errors: ['You do not authorized!']})
      else
        unquote(expression)
      end
    end
  end

  @doc """
  Checks authorization by reading JWT token from the Authorization header and then check it through
  the existed tokens.
  """
  @spec check_authorization(Request.t) :: boolean
  def check_authorization(remark_api_request) do
    Request.header(remark_api_request, "authorization")
    |> Utils.UserTokenService.verify_token
  end
end
