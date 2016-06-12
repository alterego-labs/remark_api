defmodule RemarkApi.Token do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  schema "tokens" do
    field :value, :string

    belongs_to :user, RemarkApi.User

    timestamps
  end

  def changeset(token, params \\ :empty) do
    token
    |> cast(params, ~w(value user_id))
    |> validate_required(:value)
    |> assoc_constraint(:user)
  end

  def for_value(query, value) do
    from t in query,
    where: t.value == ^value
  end

  def first_for_value(value) do
    __MODULE__
    |> for_value(value)
    |> preload(:user)
    |> first
    |> RemarkApi.Repo.one
  end

  def for_user(query, user) do
    from e in query,
    where: e.user_id == ^user.id
  end
end
