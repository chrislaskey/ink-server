use Mix.Config

config :oauth2_login, OAuth2Login.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "oauth2_login_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
