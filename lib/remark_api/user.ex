defmodule RemarkApi.User do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  alias RemarkApi.Repo

  schema "users" do
    field :login, :string
    field :android_token, :string
    field :ios_token, :string
    field :password, :string

    has_many :messages, RemarkApi.Message, on_delete: :delete_all
    has_many :tokens, RemarkApi.Token, on_delete: :delete_all

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

  def changeset_register(user, params \\ :empty) do
    user
    |> cast(params, ~w(login password))
    |> validate_required(:login)
    |> validate_required(:password)
    |> validate_format(:login, ~r/^[a-z0-9_-]*$/)
    |> validate_length(:login, min: 3, max: 10)
    |> validate_length(:password, min: 6, max: 10)
    |> unique_constraint(:login)
  end

  def update_push_token(user, %{"type" => type, "value" => value}) do
    token_column = "#{type}_token" |> String.to_atom
    user = Ecto.Changeset.change(user, %{token_column => value})
    {:ok, _} = Repo.update user
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

  def with_present_android_token(query) do
    from u in query,
    where: not is_nil(u.android_token) and u.android_token != ""
  end
end
