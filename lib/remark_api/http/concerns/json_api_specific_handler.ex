defmodule RemarkApi.Http.Concerns.JsonApiSpecificHandler do
  @moduledoc """
  Provides basic skeleton to create custom specific handlers.

  ## Usage

  To define your custom JSON API specific handler use this module in the target one:

  ```elixir
  defmodule RemarkApi.Http.Handlers.Api.V1.Login do
    use RemarkApi.Http.Concerns.JsonApiSpecificHandler
    ...
  end
  ```

  The next step is to define processing functions. Such functions must be named `process/2` and
  accepts two parameters:

  1. HTTP method string
  2. *RemarkApi.Http.Request* struct

  Example of implementation:

  ```elixir
  defmodule RemarkApi.Http.Handlers.Api.V1.Login do
    use RemarkApi.Http.Concerns.JsonApiSpecificHandler

    def process("GET", remark_api_request)
      # Your processing logic here...
    end
  end
  ```
  """

  defmacro __using__(_opts \\ []) do
    quote do
      import RemarkApi.Http.Utils.SpecificHandlerResponseBuilder
      import RemarkApi.Http.Concerns.Authorization

      @before_compile __MODULE__
    end
  end

  @doc false
  defmacro __before_compile__(_env) do
    quote do
      def process(_method, _remark_api_request) do
        make_method_not_allowed_response
      end
    end
  end
end
