use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ink_server, InkServer.Endpoint,
  http: [port: 4011],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ink_server, InkServer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("INK_SERVER_POSTGRES_USER"),
  password: System.get_env("INK_SERVER_POSTGRES_PASS"),
  database: System.get_env("INK_SERVER_POSTGRES_DB") <> "_test",
  hostname: System.get_env("INK_SERVER_POSTGRES_HOST"),
  pool: Ecto.Adapters.SQL.Sandbox
