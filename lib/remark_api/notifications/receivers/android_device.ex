defmodule RemarkApi.Notifications.Receivers.AndroidDevice do
  @moduledoc """
  Implementation for android devices receivers. 

  The list of target devices is prepared from users that have filled appropriate field.

  ## Example

    RemarkApi.Notifications.Receivers.AndroidDevice.call(%{"key" => "value"})
  """

  alias RemarkApi.Notifications.Sources
  alias RemarkApi.Notifications.Receivers

  @doc """
  Starts sending notifications to all available devices
  """
  @spec call(map) :: none
  def call(message_hash) do
    {:ok, message_json_string} = JSX.encode(message_hash)
    Sources.AndroidDevices.get
    |> Enum.each(&process_client(&1, message_json_string))
  end

  defp process_client(device_token, message_json_string) do
    Receivers.GcmServer.send(device_token, message_json_string)
  end
end
