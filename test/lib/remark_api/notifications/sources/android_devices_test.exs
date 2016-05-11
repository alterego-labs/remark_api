defmodule RemarkApi.Notifications.Sources.AndroidDevicesTest do
  use TestCaseWithDbSandbox, async: true

  alias RemarkApi.Notifications.Sources

  test "get return proper result" do
    user = create(:user)
    user1 = create(:user, android_token: "asdajsdhasls")
    user2 = create(:user, android_token: "")
    tokens = Sources.AndroidDevices.get
    assert tokens = ["asdajsdhasls"]
  end
end
