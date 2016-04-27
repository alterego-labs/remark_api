defmodule RemarkApi.Http.Processors.Api.V1.Messages do
  alias RemarkApi.{Pagination, Message, Repo}

  def get_messages(options \\ []) do
    user = Keyword.get(options, :user, nil)
    pagination = Keyword.get(options, :pagination, nil)
    do_filter_by_user(user)
    |> Message.recent
    |> do_pagination(pagination)
    |> Repo.all
    |> Repo.preload(:user)
    |> RemarkApi.Serializers.Message.cast
  end

  defp do_filter_by_user(nil = _user), do: Message
  defp do_filter_by_user(%RemarkApi.User{} = user) do
    Message
    |> Message.for_user(user)
  end

  defp do_pagination(query, nil = _pagination), do: query
  defp do_pagination(query, pagination) do
    Pagination.apply(query, pagination)
  end
end
