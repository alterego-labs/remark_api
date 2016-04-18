defmodule RemarkApi.Http.Processors.Api.V1.Messages do
  def get_messages(user \\ nil) do
    do_filter_by_user(user)
    |> RemarkApi.Message.recent
    |> RemarkApi.Repo.all
    |> RemarkApi.Repo.preload(:user)
    |> RemarkApi.Serializers.Message.cast
  end

  defp do_filter_by_user(nil) do
    RemarkApi.Message
  end

  defp do_filter_by_user(%RemarkApi.User{} = user) do
    RemarkApi.Message
    |> RemarkApi.Message.for_user(user)
  end
end
