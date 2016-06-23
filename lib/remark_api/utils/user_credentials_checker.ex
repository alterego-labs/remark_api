defmodule RemarkApi.Utils.UserCredentialsChecker do
  alias RemarkApi.{User, Repo}

  @doc """
  Performs checking credentials.
  """
  @spec check(String.t, String.t) :: {true, User.t} | {false, nil}
  def check(login, password) do
    login
    |> User.find_by_login
    |> process_by_user(password)
  end

  defp process_by_user(nil, _password), do: {false, nil}
  defp process_by_user(%User{} = user, password) do
    user.password
    |> password_check(password)
    |> process_by_password_check_result(user)
  end

  defp password_check(password1, password2) do
    password1 == password2
  end

  defp process_by_password_check_result(true, user) do
    {true, user}
  end
  defp process_by_password_check_result(false, _user), do: {false, nil}
end
