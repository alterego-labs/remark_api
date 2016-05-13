defmodule RemarkApi.Htto.Processors.Api.V1.UserMessagesTest do
  use TestCaseWithDbSandbox

  import Mock

  test "get all messages for user but it does not found" do
    res = RemarkApi.Http.Processors.Api.V1.UserMessages.get_all("unexisted_user")
    assert {:not_found, _} = res
  end

  test "get all messages for user successfully" do
    user = build(:user) |> create |> with_message
    res = RemarkApi.Http.Processors.Api.V1.UserMessages.get_all(user.login)
    assert {:ok, messages} = res
    assert Enum.count(messages) == 1
  end

  test "put new successfully" do
    with_mock RemarkApi.Notifications.Point, [notify: fn(_)-> :ok end] do
      user = create(:user)
      body = %{"message" => %{"body" => "Some message"}}
      res = RemarkApi.Http.Processors.Api.V1.UserMessages.put_new_for(user.login, body)
      assert {:ok, _message} = res
    end
  end
end
