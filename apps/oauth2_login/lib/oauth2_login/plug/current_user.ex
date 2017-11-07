defmodule OAuth2Login.Plug.CurrentUser do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    case Guardian.Plug.current_resource(conn) do
      nil -> conn
      user ->
        put_private(conn, :plug_oauth2_login, %{current_user: user})
    end
  end
end
