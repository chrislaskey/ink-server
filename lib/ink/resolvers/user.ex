defmodule Ink.Resolver.User do
  require Logger

  alias Ink.Repo
  alias Ink.CurrentUser
  alias Ink.Session
  alias Ink.User
  alias Ink.LogIn.Facebook
  alias Ink.LogIn.GitHub
  alias Ink.User.Instance, as: UserInstance
  alias Ink.UserProvider.Instance, as: UserProviderInstance

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

  def log_in_with_provider(params, _info) do
    with {:ok, data} <- get_provider_data(params),
         {:ok, user} <- UserInstance.find_or_create_by_provider(data[:user], data[:provider]),
         {:ok, _} <- UserProviderInstance.create_or_update_by(user, data[:provider]),
         {:ok, jwt, %{"exp" => expires}} <- Guardian.encode_and_sign(user, :access) do
      Logger.debug "Session: " <> inspect(%{token: jwt, token_expiration: expires, user: user})
      {:ok, %{token: jwt, token_expiration: expires, user: user}}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp get_provider_data(%{code: code, provider: provider, redirect_uri: redirect_uri}) do
    case provider do
      "facebook" -> Facebook.fetch(code, redirect_uri)
      "github" -> GitHub.fetch(code, redirect_uri)
      _ -> {:error, "Provider #{provider} not supported"}
    end
  end
end
