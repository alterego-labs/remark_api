defmodule RemarkApi.Serializers.User do
  def cast(users) when is_list(users) do
    users |> Enum.map(&cast(&1))
  end

  def cast(user) do
    %{
      login: user.login
    }
  end
end
