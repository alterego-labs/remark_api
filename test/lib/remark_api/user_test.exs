defmodule RemarkApi.UserTest do
  use TestCaseWithDbSandbox, async: true

  alias RemarkApi.User

  test "update push token" do
    user = create(:user)
    token = "oiaxumr2389muxpu23pz23o"
    token_body = %{"type" => "android", "value" => token}
    res = User.update_push_token(user, token_body)
    user = User.find_by_login(user.login)
    assert user.android_token == token
  end
end
