defmodule RemarkApi.Http.Processors.Api.V1.UserToken do
  @attach_schema %{
    "type" => "object",
    "properties" => %{
      "token" => %{
        "type" => "object",
        "properties" => %{
          "type" => %{
            "type" => "string",
          },
          "value" => %{
            "type" => "string"
          }
        }
      }
    }
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
    
  end
end
