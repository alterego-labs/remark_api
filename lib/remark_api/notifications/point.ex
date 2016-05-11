defmodule RemarkApi.Notifications.Point do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link __MODULE__, :ok, name: NotificationsPoint
  end

  def init(:ok) do
    {:ok, 0}
  end

  def notify(message_hash) do
    GenServer.cast NotificationsPoint, {:notify, message_hash}
  end

  def handle_cast({:notify, message_hash}, _from, state) do
    RemarkApi.Notifications.call(:websocket, message_hash)
    RemarkApi.Notifications.call(:android_device, message_hash)
    {:noreply, state}
  end
end
