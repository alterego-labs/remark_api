defmodule RemarkApi.Notifications.Sources.WebsocketClients do
  def get do
    RemarkApi.WsClientsRepo.clients   
  end
end
