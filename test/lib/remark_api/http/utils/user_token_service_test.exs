defmodule RemarkApi.Http.Utils.UserTokenServiceTest do
  use TestCaseWithDbSandbox

  test "add_token adds new token for the user" do
    user = create(:user)
    
    user = Repo.preload user, :tokens

    assert Enum.count(user.tokens) == 0

    RemarkApi.Http.Utils.UserTokenService.add_token(user)

    user = Repo.preload user, :tokens, force: true

    assert Enum.count(user.tokens) == 1
  end
end
