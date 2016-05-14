defmodule RemarkApi.Serializers.Message do
  @moduledoc """
  Serializes RemarkApi.Message struct into Map.

  ## Example of serializing single message

    message = %RemarkApi.Message{body: "Some", id: 1}
    RemarkApi.Serializes.Message.cast(message) # => %{body: "Some", id: 1, user: %{...}}

  ## Example of serializing the bunch of messages

    messages = [%RemarkApi.Message{body: "Some", id: 1}, ...]
    RemarkApi.Serializes.Message.cast(messages) # => [%{body: "Some", id: 1, user: %{...}}, ...]
  """

  alias RemarkApi.Repo

  @doc false
  @spec cast(list(RemarkApi.Message.t)) :: list(map)
  def cast(messages) when is_list(messages) do
    messages |> Enum.map(&cast(&1))
  end

  @doc false
  @spec cast(RemarkApi.Message.t) :: map
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
