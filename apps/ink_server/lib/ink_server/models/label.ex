defmodule InkServer.Label do
  use InkServer.Web, :model

  schema "labels" do
    field :name, :string
    field :color, :string
    field :note_count, :integer, virtual: true
    belongs_to :user, InkServer.User
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
end
