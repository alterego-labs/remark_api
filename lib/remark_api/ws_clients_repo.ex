defmodule RemarkApi.WsClientsRepo do
  @bucket :ws_clients

  @moduledoc """
  Provides managed shared state to keep group of active WS connections.
  """

  def create, do: :pg2.create(@bucket)

  def add(pid), do: :pg2.join(@bucket, pid)

  def remove(pid), do: :pg2.leave(@bucket, pid)

  def clients, do: :pg2.get_members(@bucket)
end
