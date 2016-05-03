defmodule RemarkApi.Http.Processors.Api.V1.UserTokenTest do
  use TestCaseWithDbSandbox, async: true

  alias RemarkApi.Http.Processors.Api.V1.UserToken

  test "attach when user not found" do
    res = UserToken.attach("ahhasdadsd", %{})
    assert {:not_found, %{}} = res
  end

  test "attach when body schema is invalid" do
    user = create(:user)
    body = %{"some" => "a"}
    res = UserToken.attach(user.login, body)
    assert {:error, _} = res
  end

  test "attach when body schema is valid, but type is not" do
    user = create(:user)
    body = %{"token" => %{"type" => "some", "value" => "adjm2x8238,z23r3"}}
    res = UserToken.attach(user.login, body)
    assert {:error, _} = res
  end

  test "attach when body is fully valid and user exists" do
    user = create(:user)
    token = "orq3892prxu2upr23pz23or,32"
    body = %{"token" => %{"type" => "android", "value" => token}}
    res = UserToken.attach(user.login, body)
    assert {:ok, _} = res
  end
end
