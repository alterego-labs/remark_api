defmodule RemarkApi.Notifications.Sources.AndroidDevices do
  @moduledoc """
  Provides preparing sources for sending push notifications to android devices.

  ## Basic example of usage
    RemarkApi.Notifications.Sources.AndroidDevices.get # => ["alsdjajsd", ...]
  """

  alias RemarkApi.{User, Repo}
  import Ecto.Query

  @doc """
  The main entry for fetching android devices tokens
  """
  def get do
    query = construct_query
    Repo.all(query)
  end

  defp construct_query do
    filter_query = User |> User.with_present_android_token
    from u in filter_query, select: u.android_token
  end
end

