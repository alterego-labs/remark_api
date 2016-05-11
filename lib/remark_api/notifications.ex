defmodule RemarkApi.Notifications do
  alias RemarkApi.Notifications.Receivers

  def call(:websocket, message_hash), do: Receivers.Websocket.call(message_hash) 
  def call(:android_device, message_hash), do: Receivers.AndroidDevice.call(message_hash)
end
