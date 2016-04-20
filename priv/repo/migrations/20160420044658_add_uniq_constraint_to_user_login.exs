defmodule RemarkApi.Repo.Migrations.AddUniqConstraintToUserLogin do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:login])
  end
end
