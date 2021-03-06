defmodule RemarkApi.Http.Processors.Api.V1.UserTest do
  use TestCaseWithDbSandbox

  test "no user with requested login not found" do
    resp = RemarkApi.Http.Processors.Api.V1.User.get_info("some_login") 
    assert {:not_found, %{}} = resp
  end

  test "user with requested login found" do
    user = create(:user)
    resp = RemarkApi.Http.Processors.Api.V1.User.get_info(user.login) 
    assert {:ok, _} = resp
  end
end
