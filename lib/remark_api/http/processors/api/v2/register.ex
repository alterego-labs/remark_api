defmodule RemarkApi.Http.Processors.Api.V2.Register do
  @attach_schema %{
    "type" => "object",
    "properties" => %{
      "user" => %{
        "type" => "object",
        "properties" => %{
          "login" => %{
            "type" => "string"
          },
          "password" => %{
            "type" => "string"
          }
        },
        "required" => ["login", "password"]
      }
    },
    "required" => ["user"]
  }

  alias RemarkApi.{User, Repo}
  import RemarkApi.Helper

  def call(body) do
    body
    |> validate_body_schema
    |> process_with_validation_result(body)
  end

  defp validate_body_schema(body) do
    ExJsonSchema.Validator.validate(@attach_schema, body)
  end

  defp process_with_validation_result(:ok, body) do
    params = Map.get(body, "user")
    %User{}
    |> User.changeset_login(params)
    |> Repo.insert
    |> process_by_insert_result
  end
  defp process_with_validation_result({:error, errors}, _body) do
    {:invalid_schema, errors}
  end

  defp process_by_insert_result({:ok, user}) do
    hash = RemarkApi.Serializers.User.cast(user)
    {:ok, hash}
  end
  defp process_by_insert_result({:error, changeset}) do
    {:invalid_data, pretty_errors(changeset.errors)}
  end
end
