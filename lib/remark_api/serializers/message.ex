defmodule RemarkApi.Serializers.Message do
  alias RemarkApi.Repo

  def cast(messages) when is_list(messages) do
    messages |> Enum.map(&cast(&1))
  end
  def cast(message) do
    message = Repo.preload(message, :user)
    %{
      id: message.id,
      body: message.body,
      created_at: Ecto.DateTime.to_string(message.inserted_at),
      user: serialize_user(message.user)  
    }
  end

  defp serialize_user(user) do
    RemarkApi.Serializers.User.cast(user)
  end
end
