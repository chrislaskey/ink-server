defmodule InkServer.Plug.CurrentUser do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case InkServer.Auth.get_user(conn) do
      nil ->
        conn
      user ->
        put_private(conn, :plug_auth, %{current_user: user})
    end
  end
end
