defmodule RemarkApi.Serializers.User do
  @moduledoc """
  Serializes RemarkApi.User struct into Map.

  ## Example of serializing single user

    user = %RemarkApi.User{login: "user1"}
    RemarkApi.Serializes.User.cast(user) # => %{login: "user1"}

  ## Example of serializing the bunch of users

    users = [%RemarkApi.User{login: "user2"}, ...]
    RemarkApi.Serializes.User.cast(users) # => [%{login: "user2"}, ...]
  """

  @doc false
  @spec cast(list(RemarkApi.User.t)) :: list(map)
  def cast(users) when is_list(users) do
    users |> Enum.map(&cast(&1))
  end

  @doc false
  @spec cast(RemarkApi.User.t) :: map
  def cast(user) when not is_nil(user) do
    %{
      login: user.login
    }
  end

  @doc false
  @spec cast(nil) :: %{}
  def cast(nil) do
    %{}
  end
end
