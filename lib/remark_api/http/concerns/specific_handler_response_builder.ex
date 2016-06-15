defmodule RemarkApi.Http.Concerns.SpecificHandlerResponseBuilder do
  @moduledoc """
  Provides for specific handler convinient way to construct responses for common handler.
  """

  @doc """
  Constructs OK response with custom data
  """
  @spec make_ok_response(map) :: {:ok, map}
  def make_ok_response(data \\ %{}), do: {:ok, data}

  @doc """
  Constructs Not Found response with custom data
  """
  @spec make_not_found_response(map) :: {:not_found, map}
  def make_not_found_response(data \\ %{}), do: {:not_found, data}

  @doc """
  Constructs Bad Request response with custom data
  """
  @spec make_bad_request_response(map) :: {:bad_request, map}
  def make_bad_request_response(data \\ %{}), do: {:bad_request, data}

  @doc """
  Constructs Unauthorized response with custom data
  """
  @spec make_unauhtorized_response(map) :: {:unauhtorized, map}
  def make_unauhtorized_response(data \\ %{}), do: {:unauhtorized, data}

  @doc """
  Constructs Method Not Allowed response with custom data
  """
  @spec make_method_not_allowed_response(map) :: {:method_not_allowed, map}
  def make_method_not_allowed_response(data \\ %{}), do: {:method_not_allowed, data}

  @doc """
  Constructs Unprocessable Entity response with custom data
  """
  @spec make_unprocessable_entity_response(map) :: {:unprocessable_entity, map}
  def make_unprocessable_entity_response(data \\ %{}), do: {:unprocessable_entity, data}
end
