defmodule RemarkApi.Notifications.Receivers.GcmServer do
  use HTTPotion.Base

  @google_api_key "AIzaSyAp0MJ4aTJs1-GiCMch0dMMoN3R5XRtIoc"

  def send(device_token, message_json_string) do
    post('/', [body: {device_token, message_json_string}])
  end

  def process_url(url) do
    "https://gcm-http.googleapis.com/gcm/send"
  end

  def process_request_headers(headers) do
    headers
    |> Dict.put(:"Authorization", "key=#{@google_api_key}")
    |> Dict.put(:"Content-Type", "application/json")
  end

  def process_request_body({device_token, message_json_string}) do
    """
    {
      "data": {
        "notification": {
          "subject": "New remark!",
          "message": #{message_json_string}
        }
      },
      "to": "#{device_token}"
    }
    """
  end
end
