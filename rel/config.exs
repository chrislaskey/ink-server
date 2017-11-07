Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"4Pp*uBBDiILL8w:6&/q&sw^Y=x/C^N~7jE{e)wH9jULu.Z&]:mQqkTy5@a}Cn$hv"
end

release :ink_server do
  set version: "0.1.0"
  set applications: [
    :runtime_tools,
    ink_api: :permanent,
    ink_pubsub: :permanent,
    ink_server: :permanent,
    oauth2_login: :permanent
  ]
end
