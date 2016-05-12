defmodule RemarkApi.Notifications.Receivers.Websocket do
  alias RemarkApi.Notifications.Sources

  def call(message_hash) do
    {:ok, message_json_string} = JSX.encode(message_hash)
    Sources.WebsocketClients.get
    |> Enum.each(&process_client(&1, message_json_string))
  end

  defp process_client(client_pid, message_json_string) do
    send client_pid, {:message, message_json_string}
  end
end
