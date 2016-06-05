defmodule RemarkApi.Repo.Migrations.AddPasswordToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :title, :string
    end
  end
end
