defmodule InkServer.Label do
  import Ecto.Query, only: [from: 2]

  use InkServer.Schema

  schema "labels" do
    field :name, :string
    field :color, :string
    field :note_count, :integer, virtual: true
    belongs_to :user, InkServer.User, type: :binary_id
    many_to_many :notes, InkServer.Note, join_through: "labels_notes"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:color, :name, :user_id])
    |> validate_required([:color, :name, :user_id])
  end

  # Queries

  def owner?(id, user_id) do
    case Repo.get_by(Label, %{id: id, user_id: user_id}) do
      nil -> {:error, "Label #{id} not owned by user"}
      label -> {:ok, label}
    end
  end

  def add_counts(labels) do
    for label <- labels, do: add_count(label)
  end

  def add_count(label) do
    query = from l in Label,
      join: n in assoc(l, :notes),
      where: [id: ^label.id],
      limit: 1,
      select: count(n.id)
    count = hd(Repo.all(query))

    Map.put(label, :note_count, count)
  end
end
