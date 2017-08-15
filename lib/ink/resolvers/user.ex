defmodule Ink.Resolver.User do
  require Logger

  alias Ink.Repo
  alias Ink.CurrentUser
  alias Ink.Session
  alias Ink.User
  alias Ink.User.Instance, as: UserInstance

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
    with {:ok, user_data} <- get_provider_user(params),
         {:ok, user} <- UserInstance.find_or_create_by(user_data),
         {:ok, jwt, %{"exp" => expires}} <- Guardian.encode_and_sign(user, :access) do
      {:ok, %{token: jwt, token_expiration: expires, user: user}}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp get_provider_user(%{code: code, provider: provider, redirect_uri: redirect_uri}) do
    case provider do
      "facebook" -> get_facebook_user(code, redirect_uri)
      _ -> {:error, "Provider #{provider} not supported"}
    end
  end

  defp get_facebook_user(code, redirect_uri) do
    try do
      client = OAuth2.Provider.Facebook.get_token!([code: code], [redirect_uri: redirect_uri])
      token = client.token

      Logger.debug "Facebook client: " <> inspect(client)

      case token.access_token do
        nil -> {:error, "Error fetching facebook token: " <> token.other_params["error_description"]}
        _ -> get_facebook_user_details(client)
      end
    rescue
      error in ArgumentError -> Logger.error inspect(error)
        {:error, "Error fetching facebook token"}
    end
  end

  defp get_facebook_user_details(client) do
    case OAuth2.Provider.Facebook.get_user(client) do
      {:error, response} -> {:error, response}
      {:ok, user} ->
        {:ok, %{
          provider_name: :facebook,
          provider_id: user["id"],
          locale: user["locale"],
          email: user["email"],
          first_name: user["first_name"],
          last_name: user["last_name"],
          name: user["name"]
        }}
    end
  end
end
