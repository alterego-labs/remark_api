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
end
