defmodule InkApi.Resolver.Note do
  import Ecto.Query, only: [from: 2, where: 2]

  alias InkApi.Repo
  alias InkApi.CurrentUser
  alias InkApi.Note
  alias InkApi.Note.Instance, as: NoteInstance
  alias InkApi.Label.Instance, as: LabelInstance

  def all(_params, info) do
    notes = Note
      |> where(user_id: ^CurrentUser.id info)
      |> Repo.all
      |> Repo.preload([:labels])

    {:ok, notes}
  end

  def search(params, info) when params == %{}, do: all(%{}, info)
  def search(%{search: search}, info) when is_nil(search), do: all(%{}, info)
  def search(%{search: search}, info) when search == "", do: all(%{}, info)
  def search(%{search: search}, info) do
    notes = Repo.all(
        from n in Note,
        where: [user_id: ^CurrentUser.id info],
        where: (
          ilike(n.title, ^"%#{search}%") or
          ilike(n.body, ^"%#{search}%")
        )
      )
      |> Repo.preload([:labels])

    {:ok, notes}
  end

  def find(%{uid: uid}, info) do
    case Repo.get_by(Note, uid: uid, user_id: CurrentUser.id info) do
      nil -> {:error, "Note #{uid} not found"}
      note -> {:ok, note}
    end
  end

  def find_by_secret(%{uid: uid, secret: secret}, _info) do
    case Repo.get_by(Note, %{secret: secret, uid: uid}) do
      nil -> {:error, "Note #{uid} not found"}
      note -> {:ok, note}
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

  def update(%{uid: uid, note: note_params}, info) do
    params = CurrentUser.add(note_params, info)

    Repo.get_by!(Note, uid: uid, user_id: CurrentUser.id info)
    |> Note.update_changeset(params)
    |> Repo.update
  end

  def delete(%{uid: uid}, info) do
    note = Repo.get_by!(Note, uid: uid, user_id: CurrentUser.id info)

    Repo.delete(note)
  end

  def add_label(%{label_id: label_id, uid: uid}, info) do
    with {:ok, label} <- LabelInstance.owner?(label_id, CurrentUser.id info),
         {:ok, note} <- NoteInstance.owner?(uid, CurrentUser.id info) do
      params = %{
        labels: [ label | NoteInstance.labels(note) ]
      }

      note
      |> Repo.preload([:labels, :user])
      |> Note.label_changeset(params)
      |> Repo.update
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def remove_label(%{label_id: label_id, uid: uid}, info) do
    with {:ok, label} <- LabelInstance.owner?(label_id, CurrentUser.id info),
         {:ok, note} <- NoteInstance.owner?(uid, CurrentUser.id info) do
      params = %{
        labels: List.delete(NoteInstance.labels(note), label)
      }

      note
      |> Repo.preload([:labels, :user])
      |> Note.label_changeset(params)
      |> Repo.update
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
