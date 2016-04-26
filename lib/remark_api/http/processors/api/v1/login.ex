defmodule RemarkApi.Http.Processors.Api.V1.Login do
  alias RemarkApi.{User, Repo}

  import RemarkApi.Helper

  @doc """
  Calls login processor.
  """
  @spec call(map) :: {:ok, map} | {:error, list}
  def call(data) do
    data
    |> fetch_login
    |> User.find_by_login
    |> process_by_user(data)
  end

  defp fetch_login(data) do
    Map.get(data, :user, %{}) |> Map.get(:login, nil)
  end

  defp process_by_user(user, data) when not is_nil(user) do
    hash = RemarkApi.Serializers.User.cast(user)
    {:ok, hash}
  end
  defp process_by_user(nil, data) do
    data
    |> Map.get(:user, %{})
    |> try_to_create_user
  end

  @spec try_to_create_user(map) :: {:ok, map} | {:error, list}
  defp try_to_create_user(params) do
    User.changeset_login(%User{}, params)
    |> Repo.insert
    |> process_by_insert_result
  end

  defp process_by_insert_result({:ok, user}) do
    hash = RemarkApi.Serializers.User.cast(user)
    {:ok, hash}
  end
  defp process_by_insert_result({:error, changeset}) do
    {:error, pretty_errors(changeset)}
  end
end
