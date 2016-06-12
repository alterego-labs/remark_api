defmodule RemarkApi.Serializers.MessageTest do
  use TestCaseWithDbSandbox

  import RemarkApi.Factory
  alias RemarkApi.Repo

  test "success serialization of one message with user" do
    message = create(:message, user: create(:user))
    hash = RemarkApi.Serializers.Message.cast(message)
    assert is_map(hash)
    assert hash[:body] == message.body
    assert Map.has_key?(hash, :user)
  end

  test "success serialization of one message without user" do
    message = create(:message)
    hash = RemarkApi.Serializers.Message.cast(message)
    assert is_map(hash)
    assert hash[:body] == message.body
    assert Map.has_key?(hash, :user)
  end

  test "success serialization of many message with user" do
    messages = create_list(3, :message, user: create(:user))
    hash = RemarkApi.Serializers.Message.cast(messages)
    assert is_list(hash)
    assert Enum.count(hash) == 3
  end

  test "success serialization of many message without user" do
    messages = create_list(2, :message)
    hash = RemarkApi.Serializers.Message.cast(messages)
    assert is_list(hash)
    assert Enum.count(hash) == 2
  end
end
