defmodule InkServer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ink_server,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {InkServer.Application, []}
    ]
  end

  defp deps do
    [
      {:postgrex, "~> 0.13.3"},
      {:ecto, "~> 2.2"},
      {:comeonin, "~> 2.5"},
      {:guardian, "~> 0.14.4"},
      {:faker, "~> 0.7"},
      {:hashids, "~> 2.0"},
      {:ink_pubsub, in_umbrella: true},
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
