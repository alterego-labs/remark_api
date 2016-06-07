defmodule RemarkApi.Factory do
  use ExMachina.Ecto, repo: RemarkApi.Repo

  def factory(:user) do
    %RemarkApi.User{
      login: random_valid_user_login
    }
  end

  def factory(:message) do
    %RemarkApi.Message{
      body: Faker.Lorem.paragraph
    }
  end

  def with_message(%RemarkApi.User{} = user) do
    create(:message, user: user)
    user
  end

  def random_valid_user_login do
    Faker.Lorem.characters(%Range{first: 3, last: 10})
    |> to_string
    |> String.downcase
  end
end
