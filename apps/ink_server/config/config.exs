use Mix.Config

config :ink_server,
  ecto_repos: [InkServer.Repo],
  namespace: InkServer,
  auth_client: OAuth2Login.Client

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "InkServer",
  ttl: { 30, :days },
  verify_issuer: true,
  secret_key: System.get_env("GUARDIAN_SECRET_KEY"),
  serializer: InkServer.Guardian.Serializer

import_config "#{Mix.env}.exs"
