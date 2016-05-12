defmodule RemarkApi.WsClientsRepo do
  @moduledoc """
  Provides managed shared state to keep group of active WS connections.
  It looks like some kind of Agent but for keeping processes identifier.
  """

  @bucket :ws_clients

  def create, do: :pg2.create(@bucket)

  def clear, do: :pg2.delete(@bucket)

  def add(pid), do: :pg2.join(@bucket, pid)

  def remove(pid), do: :pg2.leave(@bucket, pid)

  def clients, do: :pg2.get_members(@bucket)

  def send_to_all(func) do
    clients
    |> Enum.each(func)
  end
end
