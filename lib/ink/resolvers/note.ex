defmodule Ink.Resolver.Note do
  import Ecto.Query, only: [where: 2]

  alias Ink.Repo
  alias Ink.CurrentUser
  alias Ink.Note
  alias Ink.Note.Instance, as: NoteInstance
  alias Ink.Label.Instance, as: LabelInstance

  def all(_params, info) do
    posts = Note
      |> where(user_id: ^CurrentUser.id info)
      |> Repo.all
      |> Repo.preload([:labels])

    {:ok, posts}
  end

  def find(%{uid: uid}, info) do
    case Repo.get_by(Note, uid: uid, user_id: CurrentUser.id info) do
      nil -> {:error, "Note #{uid} not found"}
      post -> {:ok, post}
    end
  end

  def find_by_secret(%{uid: uid, secret: secret}, _info) do
    case Repo.get_by(Note, %{secret: secret, uid: uid}) do
      nil -> {:error, "Note #{uid} not found"}
      post -> {:ok, post}
    end
  end

  def create(params, info) do
    params = params
             |> CurrentUser.add(info)
             |> Note.add_secret

    %Note{}
    |> Note.changeset(params)
    |> Repo.insert
    |> Note.add_uid
    |> Repo.update
  end

  def update(%{uid: uid, post: post_params}, info) do
    params = CurrentUser.add(post_params, info)

    Repo.get_by!(Note, uid: uid)
    |> Note.update_changeset(params)
    |> Repo.update
  end

  def delete(%{uid: uid}, info) do
    post = Repo.get_by!(Note, uid: uid, user_id: CurrentUser.id info)

    Repo.delete(post)
  end

  def add_label(%{label_id: label_id, uid: uid}, info) do
    with {:ok, label} <- LabelInstance.owner?(label_id, CurrentUser.id info),
         {:ok, post} <- NoteInstance.owner?(uid, CurrentUser.id info) do
      params = %{
        labels: [ label | NoteInstance.labels(post) ]
      }

      post
      |> Repo.preload([:labels, :user])
      |> Note.label_changeset(params)
      |> Repo.update
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def remove_label(%{label_id: label_id, uid: uid}, info) do
    with {:ok, label} <- LabelInstance.owner?(label_id, CurrentUser.id info),
         {:ok, post} <- NoteInstance.owner?(uid, CurrentUser.id info) do
      params = %{
        labels: List.delete(NoteInstance.labels(post), label)
      }

      post
      |> Repo.preload([:labels, :user])
      |> Note.label_changeset(params)
      |> Repo.update
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
