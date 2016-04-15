defmodule RemarkApi.User do
  use Ecto.Schema
  import Ecto.Query

  schema "users" do
    field :login, :string

    has_many :messages, RemarkApi.Message, on_delete: :delete_all

    timestamps
  end

  def with_login(query, login) do
    from u in query,
    where: u.login == ^login
  end
end
