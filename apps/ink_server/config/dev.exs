use Mix.Config

config :ink, InkServer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("INK_SERVER_POSTGRES_USER"),
  password: System.get_env("INK_SERVER_POSTGRES_PASS"),
  database: System.get_env("INK_SERVER_POSTGRES_DB"),
  hostname: System.get_env("INK_SERVER_POSTGRES_HOST"),
  pool_size: 10
