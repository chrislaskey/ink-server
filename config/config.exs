# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ink,
  ecto_repos: [Ink.Repo]

# Configures the endpoint
config :ink, Ink.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "InPSQgB4oLtbYcY+2hKtmMfw2Jrd2iAhx7vxP+jie+/aRu78bIfhxw8m7OYBI0sS",
  render_errors: [view: Ink.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ink.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Guardian
config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "Ink",
  ttl: { 30, :days },
  verify_issuer: true,
  secret_key: System.get_env("GUARDIAN_SECRET_KEY"),
  serializer: Ink.Guardian.Serializer

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
