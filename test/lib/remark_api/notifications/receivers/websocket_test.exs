defmodule RemarkApi.Notifications.Receivers.WebsocketTest do
  use TestCaseWithDbSandbox

  test "client receives correct message" do
    RemarkApi.WsClientsRepo.create
    message_hash = %{"library" => "jsx"}
    RemarkApi.WsClientsRepo.add self()
    RemarkApi.Notifications.Receivers.Websocket.call(message_hash)
    receive do
      {:message, message_json_string} -> assert message_json_string == "{\"library\":\"jsx\"}"
    end
    RemarkApi.WsClientsRepo.clear
  end
end
