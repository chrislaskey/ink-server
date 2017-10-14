defmodule Ink.Resolver.Label do
  import Ecto.Query, only: [where: 2]

  alias Ink.Repo
  alias Ink.CurrentUser
  alias Ink.Label
  alias Ink.Label.Instance, as: LabelInstance

  def all(_params, info) do
    labels = Label
      |> where(user_id: ^CurrentUser.id info)
      |> Repo.all
      |> LabelInstance.add_counts

    {:ok, labels}
  end

  def find(%{id: id}, info) do
    case Repo.get_by(Label, id: id, user_id: CurrentUser.id info) do
      nil -> {:error, "Label #{id} not found"}
      label -> {:ok, LabelInstance.add_count(label)}
    end
  end

  def create(params, info) do
    %Label{}
    |> Label.changeset(CurrentUser.add(params, info))
    |> Repo.insert
  end

  def update(%{id: id, label: label_params}, info) do
    params = CurrentUser.add(label_params, info)

    Repo.get_by!(Label, id: id, user_id: CurrentUser.id info)
    |> Label.changeset(params)
    |> Repo.update
  end

  def delete(%{id: id}, info) do
    label = Repo.get_by!(Label, id: id, user_id: CurrentUser.id info)

    Repo.delete(label)
  end
end
