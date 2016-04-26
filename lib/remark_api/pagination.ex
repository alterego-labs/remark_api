defmodule RemarkApi.Pagination do
  @moduledoc """
  Provides pagination feature for messages.
  Declares struct which contains pagination information and single entry point `apply` function
  which, obviously, applies pagination settings for a provided query.

  ## Example of usage

    pagination = %RemarkApi.Pagination{last_message_id: 10, per_page: 15}
    RemarkApi.Message
    |> RemarkApi.Message.recent
    |> RemarkApi.Pagination.apply(pagination)
    |> RemarkApi.Repo.all
  """

  defstruct last_message_id: nil, per_page: 10

  import Ecto.Query

  @doc """
  Applies pagination for messages.
  """
  # @spec apply(Ecto.Query.t, __MODULE__.t) :: Ecto.Query.t
  def apply(query, pagination) do
    query
    |> filter_by_message_id(pagination.last_message_id)
    |> limit_by(pagination.per_page)
  end

  defp filter_by_message_id(query, nil) do
    query
  end

  defp filter_by_message_id(query, last_message_id) do
    query |> where([m], m.id < ^last_message_id)
  end

  defp limit_by(query, per_page) do
    query |> limit(^per_page)
  end
end
