defmodule Ink.User.Instance do
  alias Ink.Repo
  alias Ink.User

  def find_or_create_by(%{email: email} = params) do
    case Repo.get_by(User, email: email) do
      nil -> create_by(params)
      user -> {:ok, user}
    end
  end

  defp create_by(params) do
    user = %User{}
           |> User.changeset(params)
           |> Repo.insert

    {:ok, user}
  end
end
