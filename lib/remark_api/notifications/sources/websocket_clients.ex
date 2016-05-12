defmodule RemarkApi.Notifications.Sources.WebsocketClients do
  @moduledoc """
  Provides preparing sources for sending notifications to clients that are
  connected by websocket protocol.

  ## Basic example of usage
    RemarkApi.Notifications.Sources.WebsocketClients.get # => [%PID{}, ...]
  """

  def get do
    RemarkApi.WsClientsRepo.clients   
  end
end
