defmodule RemarkApi.Repo.Migrations.AddMessagesTable do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :text
      add :user_id, :integer
      
      timestamps
    end

    create index(:messages, [:user_id])
  end
end
