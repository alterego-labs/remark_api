defmodule RemarkApi.Notifications.Receivers.GcmServer do
  use HTTPotion.Base

  @moduledoc """
  Abstraction to send notifications through GCM.

  ## Example
    
    RemarkApi.Notifications.Receivers.GcmServer.send("adasdasdasda", "{\"key\":\"value\"}")
  """

  @google_api_key Application.get_env(:remark_api, :gcm_api_key)

  @doc """
  Sends push notification to specified Android device.
  """
  @spec send(String.t, String.t) :: none
  def send(device_token, message_json_string) do
    post('/', [body: {device_token, message_json_string}])
  end

  @doc false
  def process_url(url) do
    "https://gcm-http.googleapis.com/gcm/send"
  end

  @doc false
  def process_request_headers(headers) do
    headers
    |> Dict.put(:"Authorization", "key=#{@google_api_key}")
    |> Dict.put(:"Content-Type", "application/json")
  end

  @doc false
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
