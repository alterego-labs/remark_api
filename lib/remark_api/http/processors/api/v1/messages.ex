defmodule RemarkApi.Http.Processors.Api.V1.Messages do
  def get_messages do
    RemarkApi.Message
    |> RemarkApi.Repo.all
    |> RemarkApi.Repo.preload(:user)
    |> RemarkApi.Serializers.Message.cast
  end
end
