use Mix.Config

config :ink, Ink.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "",
  database: "ink_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

