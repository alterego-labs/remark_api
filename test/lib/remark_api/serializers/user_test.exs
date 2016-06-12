defmodule RemarkApi.Serializers.UserTest do
  use TestCaseWithDbSandbox

  import RemarkApi.Factory
  alias RemarkApi.Repo

  test "valid serialization of one user" do
    user = create(:user)
    hash = RemarkApi.Serializers.User.cast(user)
    login = user.login
    assert %{login: login} = hash
  end

  test "valid serialization of bunch of users" do
    users = create_list(3, :user)
    hash = RemarkApi.Serializers.User.cast(users)
    assert Enum.count(hash) == 3
  end
end
