defmodule RemarkApi.Http.Processors.Api.V1.MessagesTest do
  use TestCaseWithDbSandbox

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
    hash = RemarkApi.Http.Processors.Api.V1.Messages.get_messages(user: user)
    assert Enum.count(hash) == 1
  end
end
