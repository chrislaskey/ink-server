defmodule Ink.Note do
  use Ink.Web, :model

  schema "posts" do
    field :uid, :string
    field :secret, :string
    field :title, :string
    field :body, :string
    belongs_to :user, Ink.User
    many_to_many :labels, Ink.Label, join_through: "labels_posts", on_replace: :delete

    timestamps()
  end

  def add_secret(params) do
    Map.put(params, :secret, Secret.create())
  end

  def add_uid({:ok, struct}) do
    %Ink.Note{id: id} = struct
    params = %{uid: Uid.encode(id)}

    uid_changeset(struct, params)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
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
end
