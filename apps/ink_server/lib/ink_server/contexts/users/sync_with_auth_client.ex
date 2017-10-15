defmodule InkServer.Context.User.SyncWithAuthClient do
  alias InkServer.User

  @user_attributes [:id, :username, :name, :first_name, :last_name, :email, :locale]

  def call(auth_client_user) do
    case User.get(Map.get(auth_client_user, :id)) do
      nil ->
        {:ok, user} = create(auth_client_user)
        user
      user ->
        user
    end
  end

  defp create(auth_client_user) do
    auth_client_user
    |> Map.take(@user_attributes)
    |> User.create
  end
end
