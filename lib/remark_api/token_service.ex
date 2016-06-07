defmodule RemarkApi.TokenService do
  @moduledoc """
  Provides functions in order to manage session tokens.
  
  The main entry is `generate_jwt/1` function, because, by default, the API generate exactly that
  kind of tokens to sign and then check requests to be sure what user requests API, is user
  registered and signed in.

  Also besides generating you can verify JWT token. For this purpose `verify_jwt/2` exists.
  """

  @doc """
  Generates JWT token depending on the user's login and current milliseconds. It means that
  the same user can has many tokens and they are uniq.
  """
  @spec generate_jwt(String.t) :: String.t
  def generate_jwt(login) do
    import Joken
    %{login: login, created_at: build_created_at}
    |> token
    |> with_signer(hs256(fetch_jwt_secret))
    |> sign 
    |> Map.get(:token)
  end

  @doc """
  Verifies JWT token by decoding it and checking login in it.
  So thuthy value will be returned if:
  - token is successfully decoded;
  - contains proper information, in particular hash with `login` entry which contains proper value.
  """
  @spec verify_jwt(String.t, String.t) :: boolean
  def verify_jwt(jwt_token, login) do
    import Joken
    jwt_token
    |> token
    |> with_validation("login", &(&1 == login))
    |> with_signer(hs256(fetch_jwt_secret))
    |> verify
    |> process_verified_token
  end

  defp fetch_jwt_secret do
    Application.get_env(:remark_api, :jwt_secret)
  end

  defp build_created_at do
    :os.system_time(:milli_seconds)
  end

  defp process_verified_token(%Joken.Token{error: nil}), do: true
  defp process_verified_token(%Joken.Token{error: _reason}), do: false
end
