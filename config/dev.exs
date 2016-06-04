use Mix.Config

config :remark_api, RemarkApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "remark_api_dev",
  username: "admin",
  password: "password",
  hostname: "localhost"

config :remark_api, RemarkApi.Http.Point,
  port: 8183
