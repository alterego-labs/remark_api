defmodule RemarkApi.Http.Processors.Api.V1.MessagesTest do
  use ExUnit.Case

  import RemarkApi.Factory
  alias RemarkApi.Repo

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  setup do
    user = build(:user) |> create |> with_message
    create(:message)
    {:ok, user: user}
  end

  test "get all messages" do
    hash = RemarkApi.Http.Processors.Api.V1.Messages.get_messages
    assert Enum.count(hash) == 2
  end

  test "get messages for concrete existed user", %{user: user} do
    hash = RemarkApi.Http.Processors.Api.V1.Messages.get_messages(user)
    assert Enum.count(hash) == 1
  end
end
