defmodule V2.RegisterTest do
  use TestCaseWithDbSandbox

  test "failure if request body schema is invalid" do
    res = ApiCall.post("v2/register", [body: %{}])
    assert res.status_code == 400
  end

  test "failure if some validations didn't pass" do
    # user = create(:user)
    res = ApiCall.post("v2/register", [body: %{user: %{login: "ah", password: "password"}}])
    assert res.status_code == 422
  end

  test "returns 200 if all info is valid" do
    login = Faker.Lorem.characters(%Range{first: 3, last: 10}) |> to_string |> String.downcase
    IO.inspect login
    res = ApiCall.post("v2/register", [body: %{user: %{login: login, password: "password"}}])
    IO.inspect res.body
    assert res.status_code == 200
  end
end
