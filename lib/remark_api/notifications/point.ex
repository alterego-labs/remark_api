defmodule RemarkApi.Notifications.Point do
  @moduledoc """
  The entry point of notifications worker process.

  For first you need to add worker into supervisor tree:
    
    defmodule RemarkApi do
      use Application

      def start(_type, _args) do
        import Supervisor.Spec, warn: false

        children = [
          worker(RemarkApi.Notifications.Point, []),
          ...
        ]

        opts = [strategy: :one_for_one, name: RemarkApi.Supervisor]
        Supervisor.start_link(children, opts)
      end
    end

  And then you can send notifications to all available source types:

    RemarkApi.Notifications.Point.notify(%{...})
  """

  use GenServer

  alias RemarkApi.Notifications.Receivers

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
    Receivers.Websocket.call(message_hash)
    Receivers.AndroidDevice.call(message_hash)
    {:noreply, state}
  end
end
