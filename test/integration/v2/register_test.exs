defmodule V2.RegisterTest do
  use TestCaseWithDbSandbox

  test "failure if request body schema is invalid" do
    res = ApiCall.post("v2/register", [body: %{}])
    assert res.status_code == 400
  end

  test "failure if some validations didn't pass" do
    res = ApiCall.post("v2/register", [body: %{user: %{login: "ah", password: "password"}}])
    assert res.status_code == 422
  end

  test "failure if already authorized user do request" do
    login = random_valid_user_login
    jwt_token = RemarkApi.TokenService.generate_jwt(login)
    create(:user, login: login) |> with_token(jwt_token)

    res = ApiCall.post("v2/register", [
      body: %{user: %{login: random_valid_user_login, password: "password"}},
      headers: ["Authorization": jwt_token]
    ])

    assert res.status_code == 401
  end

  test "returns 200 if all info is valid" do
    res = ApiCall.post("v2/register", [body: %{user: %{login: random_valid_user_login, password: "password"}}])
    assert res.status_code == 200

    data_json = Map.get(res.body, :data)
    assert Map.has_key?(data_json, :user)
    assert Map.has_key?(data_json, :jwt)
  end
end
