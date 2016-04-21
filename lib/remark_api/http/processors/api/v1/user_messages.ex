defmodule RemarkApi.Http.Processors.Api.V1.UserMessages do
  def get_all_for(login) do
    do_process(:get, login)
  end

  def put_new_for(login, body) do
    do_process(:put, login, body)
  end

  defp do_process(type, login, body \\ %{}) do
    login
    |> RemarkApi.User.find_by_login
    |> process_with_user(type, body)
  end

  defp process_with_user(nil, _type, _body) do
    {:not_found, %{}}
  end

  defp process_with_user(%RemarkApi.User{} = user, :get, _body) do
    {:ok, RemarkApi.Http.Processors.Api.V1.Messages.get_messages(user)}
  end

  defp process_with_user(%RemarkApi.User{} = user, :put, body) do
    {:ok, %{some: "another"}}
  end
end
