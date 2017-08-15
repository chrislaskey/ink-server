defmodule Ink.User.Instance do
  alias Ink.Repo
  alias Ink.User
  alias Ink.UserProvider.Instance, as: UserProviderInstance

  def find_or_create_by_provider(user_params, provider_params) do
    case UserProviderInstance.find_user(provider_params) do
      user -> {:ok, user}
      nil -> create_by(user_params)
    end
  end

  defp create_by(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert
  end
end
