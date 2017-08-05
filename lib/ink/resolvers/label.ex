defmodule Ink.Resolver.Label do
  import Ecto.Query, only: [where: 2]

  alias Ink.Repo
  alias Ink.Label

  def all(params, _info) do
    labels = Label
      |> where(user_id: ^params[:user_id])
      |> Repo.all
      |> Repo.preload([:posts])

    {:ok, labels}
  end

  def create(params, _info) do
    %Label{}
    |> Label.changeset(params)
    |> Repo.insert
  end
end
