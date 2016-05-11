defmodule RemarkApi.UserTest do
  use TestCaseWithDbSandbox, async: true

  alias RemarkApi.{User, Repo}

  test "update push token" do
    user = create(:user)
    token = "oiaxumr2389muxpu23pz23o"
    token_body = %{"type" => "android", "value" => token}
    res = User.update_push_token(user, token_body)
    user = User.find_by_login(user.login)
    assert user.android_token == token
  end

  test "filter users with present android tokens" do
    user = create(:user)
    user1 = create(:user, android_token: "asdajsdhasls")
    user2 = create(:user, android_token: "")
    users = User |> User.with_present_android_token |> Repo.all
    assert Enum.count(users) == 1
  end
end
