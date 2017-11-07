defmodule InkServer.Auth do
  alias InkServer.Context.User.SyncWithAuthClient

  def valid?(data), do: auth_client().valid?(data)

  def get_user(data) do
    data
    |> auth_client().get_user
    |> SyncWithAuthClient.call
  end

  defp auth_client do
    Application.fetch_env!(:ink_server, :auth_client)
  end
end
