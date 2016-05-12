defmodule RemarkApi.Http.Handlers.WsHandler do
  @moduledoc """
  HTTP handler for websocket connections.
  """

  @behaviour :cowboy_http_handler
  @behaviour :cowboy_websocket_handler

  alias RemarkApi.WsClientsRepo

  def init({:tcp, :http}, req, opts), do: { :upgrade, :protocol, :cowboy_websocket, req, opts }

  def websocket_init(_any, req, opts) do
    WsClientsRepo.add(self())
    { :ok, req, :no_state }
  end

  def websocket_info({ :message, message }, req, state) do
    { :reply, { :text, message }, req, state }
  end

  def websocket_handle({ :text, message }, req, state) do
    { :reply, { :text, message }, req, state }
  end

  def websocket_terminate(_reason, _req, _state) do 
    WsClientsRepo.leave(self())
    :ok
  end
end
