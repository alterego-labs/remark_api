defmodule RemarkApi.Http.Processors.Api.V1.LoginTest do
  use ExUnit.Case

  import RemarkApi.Factory
  alias RemarkApi.Repo

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "success login of existed user when params are valid" do
    user = create(:user) 
    res = RemarkApi.Http.Processors.Api.V1.Login.call(%{user: %{login: user.login}})
    assert {:ok, _} = res
  end

  test "success login of unexisted user when params are valid" do
    res = RemarkApi.Http.Processors.Api.V1.Login.call(%{user: %{login: "sergio"}})
    assert {:ok, _} = res
  end

  test "failure login when params are invalid" do
    res = RemarkApi.Http.Processors.Api.V1.Login.call(%{})
    assert {:error, _} = res
  end
end
