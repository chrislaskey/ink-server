defmodule Ink.Resolver.Label do
  alias Ink.Repo
  alias Ink.Label

  def create(params, %{context: %{current_user: %{id: id}}}) do
    %Label{}
    |> Label.changeset(add_user_id(params, id))
    |> Repo.insert
  end

  defp add_user_id(params, user_id) do
    Map.put(params, :user_id, user_id)
  end
end
