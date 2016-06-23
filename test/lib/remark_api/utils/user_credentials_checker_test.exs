defmodule RemarkApi.Utils.UserCredentialsCheckerTest do
  use TestCaseWithDbSandbox

  alias RemarkApi.Utils.UserCredentialsChecker
  alias RemarkApi.User

  test "check returns false if user with checking login does not exists" do
    assert {false, nil} = UserCredentialsChecker.check(random_valid_user_login, "password")
  end

  test "check returns false if user exists but password is wrong" do
    user_login = random_valid_user_login

    create(:user, login: user_login, password: "password")

    assert {false, nil} = UserCredentialsChecker.check(user_login, "password1")
  end

  test "check returns true if all info is valid" do
    user_login = random_valid_user_login

    create(:user, login: user_login, password: "password")

    assert {true, %User{}} = UserCredentialsChecker.check(user_login, "password")
  end
end
