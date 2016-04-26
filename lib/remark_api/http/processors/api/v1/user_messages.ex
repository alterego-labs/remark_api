defmodule RemarkApi.Http.Processors.Api.V1.UserMessages do
  import RemarkApi.Helper

  alias RemarkApi.{User, Repo, Message}

  def get_all_for(login) do
    do_process(:get, login)
  end

  def put_new_for(login, body) do
    do_process(:put, login, fetch_msg_params(body))
  end

  defp do_process(type, login, msg_params \\ %{}) do
    login
    |> RemarkApi.User.find_by_login
    |> process_with_user(type, msg_params)
  end

  defp fetch_msg_params(body) do
    body |> Map.get(:message, %{})
  end

  defp process_with_user(nil, _type, _msg_params) do
    {:not_found, %{}}
  end

  defp process_with_user(%RemarkApi.User{} = user, :get, _msg_params) do
    {:ok, RemarkApi.Http.Processors.Api.V1.Messages.get_messages(user)}
  end

  defp process_with_user(%RemarkApi.User{} = user, :put, msg_params) do
    %Message{user_id: user.id}
    |> Message.changeset_create(msg_params)
    |> Repo.insert
    |> process_by_insert_result
  end

  defp process_by_insert_result({:ok, message}) do
    hash = RemarkApi.Serializers.Message.cast(message)
    {:ok, hash}
  end
  defp process_by_insert_result({:error, changeset}) do
    {:error, pretty_errors(changeset)}   
  end
end
