defmodule RemarkApi.Http.Processors.Api.V2.Login do
  @moduledoc """
  Processor for login endpoint of API V2.
  """

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

  @doc """
  The entry point to run processor.

  It accepts request JSON body in the map represantation and performs operations on it.
  """
  @spec call(map) :: {:ok, map} | {:invalid_schema, map} | {:invalid_data, map} 
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
    login = Map.get(params, "login")
    password = Map.get(params, "password")
    RemarkApi.Utils.UserCredentialsChecker.check(login, password)
    |> process_by_checker_result
  end
  defp process_with_validation_result({:error, errors}, _body) do
    {:invalid_schema, errors}
  end

  defp process_by_checker_result({false, nil}) do
    {:invalid_credentials, %{}}
  end
  defp process_by_checker_result({true, %User{} = user}) do
    hash = RemarkApi.Serializers.User.cast(user)
    jwt_token = RemarkApi.Http.Utils.UserTokenService.add_token(user)
    {:ok, hash, jwt_token}
  end
end
