defmodule RemarkApi.Message do
  use Ecto.Schema
  import Ecto.Query

  schema "messages" do
    field :body, :string

    belongs_to :user, RemarkApi.User

    timestamps
  end

  @doc """
  Filters messages by user

  ## Examples

    messages = RemarkApi.Message
    |> RemarkApi.Message.for_user(user)
    |> RemarkApi.Repo.all

    # Or you can make alias

    alias RemarkApi.{Message, Repo}

    messages = Message
    |> Message.for_user(user)
    |> Repo.all

  """
  def for_user(query, user) do
    from e in query,
    where: e.user_id == ^user.id
  end

  def by_inserted_at(query) do
    from e in query,
    order_by: [desc: :inserted_at]
  end
end
