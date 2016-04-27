defmodule RemarkApi.User do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  alias RemarkApi.Repo

  schema "users" do
    field :login, :string

    has_many :messages, RemarkApi.Message, on_delete: :delete_all

    timestamps
  end

  def changeset_login(user, params \\ :empty) do
    user
    |> cast(params, ~w(login))
    |> validate_required(:login)
    |> validate_format(:login, ~r/^[a-z0-9_-]*$/)
    |> validate_length(:login, min: 3, max: 10)
    |> unique_constraint(:login)
  end

  def find_by_login(login) do
    __MODULE__
    |> with_login(login)
    |> Repo.one
  end

  def with_login(query, nil = login) do
    from u in query,
    where: is_nil(u.login)
  end
  def with_login(query, login) do
    from u in query,
    where: u.login == ^login
  end
end
