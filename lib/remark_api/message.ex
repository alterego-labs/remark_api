defmodule RemarkApi.Message do
  @moduledoc """
  Represents a message or remark in the system and in DB structure.

  Users can post remarks with some thoughts using different clients. That remarks are just simple
  text.
  
  This module also represents an appropriate table in the database and provides tools to access it
  from the other part of the system.
  """

  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  schema "messages" do
    field :body, :string

    belongs_to :user, RemarkApi.User

    timestamps
  end

  def changeset_create(message, params \\ :empty) do
    message
    |> cast(params, ~w(body user_id))
    |> validate_required(:body)
    |> assoc_constraint(:user)
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

  def recent(query) do
    from e in query,
    order_by: [desc: :inserted_at, desc: :id]
  end
end
