defmodule RemarkApi.Notifications.Point do
  @moduledoc """
  The entry point of notifications worker process.
  """

  use GenServer

  @doc """
  Provides casting of sending notifications.

  ## Example
    message_hash = %{"body" => "ahaha"}
    RemarkApi.Notifications.Point.notify(message_hash)
  """
  def notify(message_hash) do
    GenServer.cast NotificationsPoint, {:notify, message_hash}
  end

  def start_link(opts \\ []) do
    GenServer.start_link __MODULE__, :ok, name: NotificationsPoint
  end

  def init(:ok) do
    {:ok, 0}
  end


  def handle_cast({:notify, message_hash}, state) do
    IO.puts "handle cast!"
    RemarkApi.Notifications.call(:websocket, message_hash)
    RemarkApi.Notifications.call(:android_device, message_hash)
    {:noreply, state}
  end
end
