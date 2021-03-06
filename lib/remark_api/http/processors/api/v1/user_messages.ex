defmodule RemarkApi.Http.Processors.Api.V1.UserMessages do
  import RemarkApi.Helper

  alias RemarkApi.{User, Repo, Message, PaginationParams}

  def get_all(login, pagination \\ nil) do
    do_process(:get, login, pagination)
  end

  def put_new_for(login, body) do
    do_process(:put, login, nil, fetch_msg_params(body))
  end

  defp do_process(type, login, pagination, msg_params \\ %{}) do
    login
    |> RemarkApi.User.find_by_login
    |> process_with_user(type, pagination, msg_params)
  end

  defp fetch_msg_params(body) do
    body |> Map.get("message", %{})
  end

  defp process_with_user(nil, _type, _pagination, _msg_params) do
    {:not_found, %{}}
  end
  defp process_with_user(%RemarkApi.User{} = user, :get, pagination, _msg_params) do
    {:ok, RemarkApi.Http.Processors.Api.V1.Messages.get_messages(user: user, pagination: pagination)}
  end
  defp process_with_user(%RemarkApi.User{} = user, :put, _pagination, msg_params) do
    %Message{user_id: user.id}
    |> Message.changeset_create(msg_params)
    |> Repo.insert
    |> process_by_insert_result
    |> notify
  end

  defp process_by_insert_result({:ok, message}) do
    hash = RemarkApi.Serializers.Message.cast(message)
    {:ok, hash}
  end
  defp process_by_insert_result({:error, changeset}) do
    {:error, pretty_errors(changeset.errors)}   
  end

  defp notify({:ok, message_hash} = params) do
    RemarkApi.Notifications.Point.notify(message_hash)
    params
  end
  defp notify(params), do: params
end
