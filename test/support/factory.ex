defmodule RemarkApi.Factory do
  use ExMachina.Ecto, repo: RemarkApi.Repo

  def factory(:user) do
    %RemarkApi.User{
      login: Faker.Internet.user_name
    }
  end

  def factory(:message) do
    %RemarkApi.Message{
      body: Faker.Lorem.paragraph
    }
  end
end
