defmodule RemarkApi.Http.Utils.UserTokenService do
  @moduledoc """
  Service in order to manage tokens:
  - attach new one
  - remove some token
  """

  @type token :: String.t

  @doc """
  Adds new token for the concrete user.
  The token which was added for the user will be returned as the function result.
  """
  @spec add_token(RemarkApi.User.t) :: token
  def add_token(user) do
    RemarkApi.TokenService.generate_jwt(user.login)
    |> create_token_record(user.id)
    |> provide_add_token_response
  end

  defp create_token_record(jwt_token, user_id) do
    %RemarkApi.Token{}
    |> RemarkApi.Token.changeset(%{value: jwt_token, user_id: user_id})
    |> RemarkApi.Repo.insert
  end

  defp provide_add_token_response({:ok, token_record}) do
    token_record.value
  end
end
