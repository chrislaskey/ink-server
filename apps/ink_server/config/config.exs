# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config
#
# General application configuration
config :ink_server,
  ecto_repos: [InkServer.Repo]

# Guardian
config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "InkServer",
  ttl: { 30, :days },
  verify_issuer: true,
  secret_key: System.get_env("GUARDIAN_SECRET_KEY"),
  serializer: InkServer.Guardian.Serializer

# OAuth2 Facebook
config :oauth2_facebook, OAuth2.Provider.Facebook,
  client_id: System.get_env("FACEBOOK_APP_ID"),
  client_secret: System.get_env("FACEBOOK_APP_SECRET")

# OAuth2 GitHub
config :oauth2_github, OAuth2.Provider.GitHub,
  client_id: System.get_env("GITHUB_APP_ID"),
  client_secret: System.get_env("GITHUB_APP_SECRET")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
