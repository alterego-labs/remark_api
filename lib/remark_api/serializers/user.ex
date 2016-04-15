defmodule RemarkApi.Serializers.User do
  def cast(users) when is_list(users) do
    users |> Enum.map(&cast(&1))
  end

  def cast(user) when not is_nil(user) do
    %{
      login: user.login
    }
  end

  def cast(nil) do
    %{}
  end
end
