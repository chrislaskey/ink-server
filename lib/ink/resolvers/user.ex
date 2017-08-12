defmodule Ink.Resolver.User do
  require Logger

  alias Ink.Repo
  alias Ink.CurrentUser
  alias Ink.User
  alias Ink.Session

  def update(%{id: id, user: user_params}, info) do
    case id == CurrentUser.id(info) do
      false -> {:error, "Not authorized to update user account #{id}"}
      true -> Repo.get!(User, id)
              |> User.update_changeset(user_params)
              |> Repo.update
    end
  end

  def login(params, _info) do
    with {:ok, user} <- Session.authenticate(params, Repo),
         {:ok, jwt, %{"exp" => expires}} <- Guardian.encode_and_sign(user, :access) do
      {:ok, %{token: jwt, token_expiration: expires, user: user}}
    end
  end

  def log_in_with_provider(params, _info) do
    with {:ok, token} <- get_provider_token(params) do
      IO.puts "access_token"
      IO.puts access_token

      Logger.debug "Access token: " <> inspect(access_token)

      # token.refresh_token
      user = hd(Repo.all(User))

      {:ok, %{token: token.access_token, token_expiration: token.expires_at, user: user}}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp get_provider_token(%{code: code, provider: provider, redirect_uri: redirect_uri}) do
    case provider do
      "facebook" -> get_facebook_token(code, redirect_uri)
      _ -> {:error, "Provider #{provider} not supported"}
    end
  end

  defp get_facebook_token(code, redirect_uri) do
    try do
      client = Ueberauth.Strategy.Facebook.OAuth.get_token!([code: code], [redirect_uri: redirect_uri])
      token = client.token

      Logger.debug "Facebook client: " <> inspect(client)

      case token.access_token do
        nil -> {:error, "Error fetching facebook token: " <> token.other_params["error_description"]}
        _ -> {:ok, token}
      end
    rescue
      error in ArgumentError -> Logger.error inspect(error)
        {:error, "Error fetching facebook token"}
    end
  end
end
