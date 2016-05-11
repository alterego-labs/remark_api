defmodule RemarkApi.Notifications.Sources.AndroidDevices do
  alias RemarkApi.{User, Repo}
  import Ecto.Query

  def get do
    query = construct_query
    Repo.all(query)
  end

  defp construct_query do
    filter_query = User |> User.with_present_android_token
    from u in filter_query, select: u.android_token
  end
end

