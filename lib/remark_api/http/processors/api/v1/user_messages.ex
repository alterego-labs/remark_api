defmodule RemarkApi.Http.Processors.Api.V1.UserMessages do
  def call(login) do
    login
    |> RemarkApi.User.find_by_login
    |> process_with_user
  end

  defp process_with_user(nil) do
    {:not_found, %{}}
  end

  defp process_with_user(%RemarkApi.User{} = user) do
    {:ok, RemarkApi.Http.Processors.Api.V1.Messages.get_messages(user)}
  end
end
