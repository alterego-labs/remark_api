defmodule RemarkApi.Notifications.Receivers.AndroidDevice do
  alias RemarkApi.Notifications.Sources

  def call(message_hash) do
    {:ok, message_json_string} = JSX.encode(message_hash)
    Sources.AndroidDevices.get
    |> Enum.each(&process_client(&1, message_json_string))
  end

  defp process_client(device_token, message_json_string) do
    RemarkApi.Notifications.Receivers.GcmServer.send(device_token, message_json_string)
  end
end
