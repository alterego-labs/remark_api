defmodule RemarkApi.Pagination do
  @moduledoc """
  Provides pagination feature for messages.
  Declares struct which contains pagination information and single entry point `apply` function
  which, obviously, applies pagination settings for a provided query.

  To create pagination structure please use `build/2` function, because internally it do value
  normalization. So it can accept plenty of values: string, `nil`, `:undefined` and integers.

  ## Example of usage

    pagination = RemarkApi.Pagination.build(10, 15)
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
  def build(last_message_id, per_page) do
    %__MODULE__{
      last_message_id: normalize_value(last_message_id, nil),
      per_page: normalize_value(per_page, @default_per_page)
    }
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

  defp normalize_value(:undefined = _value, default), do: default
  defp normalize_value(nil = _value, default), do: default
  defp normalize_value(value, _default) when is_integer(value), do: value
  defp normalize_value(value, default) when is_bitstring(value) do
    case Integer.parse(value) do
      {int_value, _rest} -> int_value
      :error -> default
    end
  end
  defp normalize_value(_value, default), do: default
end
