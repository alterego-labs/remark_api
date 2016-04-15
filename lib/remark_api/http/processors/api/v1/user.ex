defmodule RemarkApi.Http.Processors.Api.V1.User do
  def get_info(login) do
    login
    |> fetch_user_by_login
    |> do_get_info
  end

  defp fetch_user_by_login(login) do
    RemarkApi.User
    |> RemarkApi.User.with_login(login)
    |> RemarkApi.Repo.one
  end

  defp do_get_info(user) when not is_nil(user) do
    {:ok, RemarkApi.Serializers.User.cast(user)}
  end

  defp do_get_info(nil) do
    {:not_found, %{}}
  end
end
