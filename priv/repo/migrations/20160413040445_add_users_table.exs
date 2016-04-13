defmodule RemarkApi.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :login, :string, size: 128

      timestamps
    end
  end
end
