defmodule RemarkApi.Repo.Migrations.AddPushTokenFieldsToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :android_token, :text
      add :ios_token, :text
    end
  end
end
