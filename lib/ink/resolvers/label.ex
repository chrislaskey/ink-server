defmodule Ink.Resolver.Label do
  import Ecto.Query, only: [where: 2]

  alias Ink.Repo
  alias Ink.Label

  def all(_args, %{context: %{current_user: %{id: id}}}) do
    labels = Label
      |> where(user_id: ^id)
      |> Repo.all

    {:ok, labels}
  end

  def create(params, %{context: %{current_user: %{id: id}}}) do
    %Label{}
    |> Label.changeset(add_user_id(params, id))
    |> Repo.insert
  end

  defp add_user_id(params, user_id) do
    Map.put(params, :user_id, user_id)
  end
end
