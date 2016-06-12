defmodule TestCaseWithDbSandbox do
  use ExUnit.CaseTemplate

  using do
    quote do
      import RemarkApi.Factory
      alias RemarkApi.Repo
    end
  end


  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(RemarkApi.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(RemarkApi.Repo, {:shared, self()})
    :ok
  end
end
