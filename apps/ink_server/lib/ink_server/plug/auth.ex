defmodule InkServer.Plug.Auth do
  use Plug.Builder

  # TODO: Move the Guardian calls into OAuth2Login and dynamically call OAuth2
  # plug based on auth_client()?

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.LoadResource
  plug InkServer.Plug.CurrentUser
end
