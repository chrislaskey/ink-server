defmodule InkApi.Plug.Context do
  @moduledoc """
  Reads the `plug_auth` key set in an earlier plug.
  Sets the Absinthe current user context under the `absinthe` key.
  """

  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    case Map.get(conn.private, :plug_auth) do
      %{current_user: user} ->
        put_private(conn, :absinthe, %{context: %{current_user: user}})
      _ ->
        conn
    end
  end
end
