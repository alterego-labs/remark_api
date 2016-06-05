defmodule RemarkApi.Token do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  schema "tokens" do
    field :value, :string

    belongs_to :user, RemarkApi.User

    timestamps
  end

  def for_user(query, user) do
    from e in query,
    where: e.user_id == ^user.id
  end
end
