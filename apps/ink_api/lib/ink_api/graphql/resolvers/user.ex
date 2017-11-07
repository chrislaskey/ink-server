defmodule InkApi.GraphQL.Resolver.User do
  require Logger

  alias InkApi.CurrentUser
  alias InkServer.Repo
  alias InkServer.Session
  alias InkServer.User

  def update(%{id: id, user: user_params}, info) do
    case id == CurrentUser.id(info) do
      false -> {:error, "Not authorized to update user account #{id}"}
      true -> Repo.get!(User, id)
              |> User.update_changeset(user_params)
              |> Repo.update
    end
  end

  def log_in(params, _info) do
    with {:ok, user} <- Session.authenticate(params, Repo),
         {:ok, jwt, %{"exp" => expires}} <- Guardian.encode_and_sign(user, :access) do
      {:ok, %{token: jwt, token_expiration: expires, user: user}}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
