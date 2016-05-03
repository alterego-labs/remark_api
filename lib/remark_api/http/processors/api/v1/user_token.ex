defmodule RemarkApi.Http.Processors.Api.V1.UserToken do
  @attach_schema %{
    "type" => "object",
    "properties" => %{
      "token" => %{
        "type" => "object",
        "properties" => %{
          "type" => %{
            "enum" => ["ios", "android"]
          },
          "value" => %{
            "type" => "string"
          }
        },
        "required" => ["type", "value"]
      }
    },
    "required" => ["token"]
  }

  def attach(login, body) do
    login
    |> RemarkApi.User.find_by_login
    |> process_with_user(body)
  end

  defp process_with_user(nil, _body) do
    {:not_found, %{}}
  end
  defp process_with_user(user, body) do
    body
    |> validate_attach_body
    |> process_with_validation_result(user, body)
  end

  defp validate_attach_body(body) do
    ExJsonSchema.Validator.validate(@attach_schema, body)
  end

  defp process_with_validation_result(:ok, user, body) do
    RemarkApi.User.update_push_token(user, body["token"])
    {:ok, %{}}
  end
  defp process_with_validation_result({:error, errors}, _user, _body) do
    {:error, errors}
  end
end
