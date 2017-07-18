defmodule Ink.Post do
  use Ink.Web, :model

  schema "posts" do
    field :title, :string
    field :body, :string
    belongs_to :user, Ink.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body])
    |> validate_required([:title, :body])
  end
end
