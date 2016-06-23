defmodule RemarkApi.Http.Handlers.Api.V2.Login do
  @moduledoc """
  Handler for login endpoint of API v2.

  ## Income data
  
  This endpoint requires the information which must be posted in the concrete JSON format. The
  schema you can found there `RemarkApi.Http.Processors.Api.V2.Login`.

  ## Responses

  There are several responses that are dependent on: posted information's schema valid or not; the
  information itself valid or not. The cases are:

    1. _When posted information schema is not valid, or some required fields are blank_ - **400**
      ```json
      {
        success: false,
        data: {
          errors: ['...', ...]
        }
      }
      ```

    2. _When some validations on the model level do not pass_ - **422**
      ```json
      {
        success: false,
        data: {
          errors: ['...', ...]
        }
      }
      ```

    3. _When all is ok, and user is successfully logged in_ - **200** with JWT token.
      ```json
      {
        success: true,
        data: {
          user: {
            // User information here
          },
          jwt: "..."
        }
      }
      ```
  """

  use RemarkApi.Http.Concerns.JsonApiSpecificHandler

  @doc """
  Handles the concrete request type, which is match by HTTP method.
  """
  @spec process(String.t, Request.t) :: {:ok, map} | {:unprocessable_entity, map} | {:not_found, map}
  def process("POST", remark_api_request) do
    require_guest(remark_api_request) do
      Request.json_body(remark_api_request)
      |> Processors.Api.V2.Login.call
      |> resolve_reply
    end
  end

  defp resolve_reply({:ok, hash, jwt_token}) do
    make_ok_response(%{user: hash, jwt: jwt_token})
  end
  defp resolve_reply({:invalid_schema, errors}) do
    make_bad_request_response(%{errors: errors})
  end
  defp resolve_reply({:invalid_data, errors}) do
    make_unprocessable_entity_response(%{errors: errors})
  end
  defp resolve_reply({:invalid_credentials, errors}) do
    make_unprocessable_entity_response(%{errors: errors})
    make_unauthorized_response(%{errors: errors})
  end
end
