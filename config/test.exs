use Mix.Config

config :remark_api,
  jwt_secret: "my_secret"

config :remark_api, RemarkApi.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  adapter: Ecto.Adapters.Postgres,
  database: "remark_api_test",
  username: "admin",
  password: "password",
  hostname: "localhost"

config :remark_api, RemarkApi.Http.Point,
  port: 8184
