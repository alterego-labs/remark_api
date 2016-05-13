defmodule RemarkApi.Http.Handlers.WsHandler do
  @moduledoc """
  HTTP handler for websocket connections.

  There are several possible types of using this handler. Let's consider them.
  
  The first one is when request from connected
  client is coming in and you can process it and send reply back and that reply will be broadcasted
  to all connected clients. For this purpose callback `websocket_handle/3` is used.

  The second type of usage is when server event is fired and you need to notify all connected clients.
  For this callback `websocket_info/3` if used. But you couldn't just use this module by calling
  appropriate function: you need concrete PID of the connected client. For this, we using process group feature
  from Erlang and when some client is connected we save his PID in that process group. And then we can
  send message to each process, for example:

    send client_pid, {:message, "{\"key\":\"value\"}"}
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
    WsClientsRepo.remove(self())
    :ok
  end
end
