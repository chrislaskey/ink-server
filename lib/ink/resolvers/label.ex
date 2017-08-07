defmodule Ink.Resolver.Label do
  import Ecto.Query, only: [where: 2]

  alias Ink.Repo
  alias Ink.CurrentUser
  alias Ink.Label

  def all(_params, info) do
    labels = Label
      |> where(user_id: ^CurrentUser.id info)
      |> Repo.all
      |> Repo.preload([:posts])

    {:ok, labels}
  end

  def create(params, info) do
    %Label{}
    |> Label.changeset(CurrentUser.add(params, info))
    |> Repo.insert
  end
end
