defmodule V1.LoginTest do
  use TestCaseWithDbSandbox

  test "failure if credentials are incorrect" do
    res = ApiCall.post("v1/login", [body: %{user: %{login: ""}}])
    assert res.status_code == 422
  end
end
