defmodule ApiCall do
  use HTTPotion.Base

  def process_url(path) do
    "http://localhost:#{test_port}/api/" <> path
  end

  def process_request_body(body) do
    Poison.encode!(body)
  end

  def process_request_headers(headers) do
    [{'content-type', 'application/json'} | headers]
  end

  def process_response_body(body) do
    try do
      Poison.decode!(body, keys: :atoms!)
    rescue
      _ -> body
    end
  end

  defp test_port do
    point_config = Application.get_env(:remark_api, RemarkApi.Http.Point)
    Keyword.get(point_config, :port)
  end
end
