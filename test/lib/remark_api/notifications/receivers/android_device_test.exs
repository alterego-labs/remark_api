defmodule RemarkApi.Notifications.Receivers.AndroidDeviceTest do
  use TestCaseWithDbSandbox

  import Mock

  alias RemarkApi.Notifications.Receivers

  test "call process each client by sending to GcmServer" do
    device_token = "adjmo8m23do8,2o32"
    message_hash = %{"to": "adasdmhaisda"}
    message_json_string = "{\"to\":\"adasdmhaisda\"}"

    create(:user, android_token: device_token)

    test_process = self()

    with_mock Receivers.GcmServer,
      [send: fn(send_device_token, send_message_json_string) -> send(test_process, {:from_send, send_device_token, send_message_json_string}) end] do
        Receivers.AndroidDevice.call(message_hash)
        # assert called Receivers.GcmServer.send(device_token, message_json_string)
      end

    receive do
      {:from_send, send_device_token, send_message_json_string} ->
        assert send_device_token == device_token
        assert send_message_json_string == message_json_string
    end
  end
end
