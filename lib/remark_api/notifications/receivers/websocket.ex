defmodule RemarkApi.Notifications.Receivers.Websocket do
  @moduledoc """
  Implementation for websocket clients receivers. 

  The list of target clients is prepared according what clients are online right now.

  ## Example

    RemarkApi.Notifications.Receivers.Websocket.call(%{"key" => "value"})
  """

  alias RemarkApi.Notifications.Sources

  @doc """
  Starts sending notifications to all available clients
  """
  @spec call(map) :: none
  def call(message_hash) do
    {:ok, message_json_string} = JSX.encode(message_hash)
    Sources.WebsocketClients.get
    |> Enum.each(&process_client(&1, message_json_string))
  end

  defp process_client(client_pid, message_json_string) do
    spawn fn ->
      send(client_pid, {:message, message_json_string})
    end
  end
end
