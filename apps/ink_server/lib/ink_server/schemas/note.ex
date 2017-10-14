defmodule InkServer.Note do
  use InkServer.Schema

  schema "notes" do
    field :uid, :string
    field :secret, :string
    field :title, :string
    field :body, :string
    belongs_to :user, InkServer.User
    many_to_many :labels, InkServer.Label, join_through: "labels_notes", on_replace: :delete

    timestamps()
  end

  def add_secret(params) do
    Map.put(params, :secret, Secret.create())
  end

  def add_uid({:ok, struct}) do
    %InkServer.Note{id: id} = struct
    params = %{uid: Uid.encode(id)}

    uid_changeset(struct, params)
  end

  # Changesets

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :user_id, :secret])
    |> validate_required([:title, :body, :user_id])
  end

  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :user_id])
    |> validate_required([:title, :body, :user_id])
  end

  def uid_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:uid])
    |> validate_required([:uid])
  end

  def label_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :user_id])
    |> put_assoc(:labels, params[:labels])
  end

  # Queries

  def owner?(uid, user_id) do
    case Repo.get_by(Note, %{uid: uid, user_id: user_id}) do
      nil -> {:error, "Note #{uid} not owned by user"}
      note -> {:ok, note}
    end
  end

  def labels(%Note{} = note) do
    Repo.preload(note, [:labels]).labels
  end
end
