defmodule RemarkApi.Helper do
  @moduledoc """
  Provides helper functions
  """

  @doc """
  Prettifies changeset error messages.
  By default `changeset.errors` returns errors as keyword list, where key is name of the field
  and value is part of message. For example, `[body: "is required"]`.
  This method transforms errors in list which is ready to pass it, for example, in response of
  a JSON API request.
  """
  @spec pretty_errors(Ecto.Changeset.t) :: [String.t]
  def pretty_errors(changeset) do
    changeset.errors
    |> Enum.map(fn({key, value}) ->
      processed_key = key |> Atom.to_string |> String.capitalize
      processed_key <> " " <> value 
    end)
  end
end
