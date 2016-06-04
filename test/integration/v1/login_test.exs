defmodule V1.LoginTest do
  use TestCaseWithDbSandbox

  test "failure if request params are malformed" do
    res = ApiCall.post("v1/login", [body: %{}])
    assert res.status_code == 422
  end

  test "failure if login in credentials is empty" do
    res = ApiCall.post("v1/login", [body: %{user: %{login: ""}}])
    assert res.status_code == 422
  end

  test "success if parameters are valid and not empty" do
    res = ApiCall.post("v1/login", [body: %{user: %{login: "sergio"}}])
    assert res.status_code == 200
  end
end
