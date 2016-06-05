use Mix.Config

config :remark_api, RemarkApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "remark_api_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

config :remark_api,
  gcm_api_key: "AIzaSyAp0MJ4aTJs1-GiCMch0dMMoN3R5XRtIoc"

import_config "#{Mix.env}.exs"
