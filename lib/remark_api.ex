defmodule RemarkApi do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(RemarkApi.Repo, []),
      worker(RemarkApi.Http.Point, []),
      worker(RemarkApi.Notifications.Point, []),
      worker(RemarkApi.TokenService, []),
      worker(RemarkApi.Http.Utils.UserTokenService, [])
    ]

    RemarkApi.WsClientsRepo.create

    opts = [strategy: :one_for_one, name: RemarkApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
