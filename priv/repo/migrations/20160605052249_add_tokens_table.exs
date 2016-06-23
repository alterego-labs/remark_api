defmodule RemarkApi.Repo.Migrations.AddTokensTable do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :value, :text
      add :user_id, :integer

      timestamps
    end

    create index(:tokens, [:user_id])
  end
end
