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

  @default_per_page 10

  defstruct last_message_id: nil, per_page: @default_per_page

  import Ecto.Query

  @doc """
  Builds pagination struct depending on an information which is fetched from a request
  """
  def build(last_message_id, nil = per_page) do
    build(last_message_id, "")
  end
  def build(last_message_id, per_page) when is_integer(per_page) do
    %__MODULE__{last_message_id: last_message_id, per_page: per_page}
  end
  def build(last_message_id, per_page) do
    normalized_per_page = case Integer.parse(per_page) do
      {value, _rest} -> value
      :error -> @default_per_page
    end
    %__MODULE__{last_message_id: last_message_id, per_page: normalized_per_page}
  end

  @doc """
  Applies pagination for messages.
  """
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
