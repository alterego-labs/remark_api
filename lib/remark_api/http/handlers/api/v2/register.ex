defmodule RemarkApi.Http.Handlers.Api.V2.Register do
  @moduledoc """
  Handler for registration endpoint of API v2.

  ## Income data
  
  This endpoint requires the information which must be posted in the concrete JSON format. The
  schema you can found there `RemarkApi.Http.Processors.Api.V2.Register`.

  ## Responses

  There are several responses that are dependent on: posted information's schema valid or not; the
  information itself valid or not. The cases are:

    1. _When posted information schema is not valid, or some required fields are blank_ - **422**
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

    3. _When all is ok, and user is successfully registered_ - **200** with JWT token.
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

  use RemarkApi.Http.Concerns.JsonApiHandler

  defp process({"POST", "application/json"}) do
    
  end
end
