defmodule InkServer.User do
  use InkServer.Schema

  alias Comeonin.Bcrypt

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :email, :string
    field :username, :string
    field :name, :string
    field :first_name, :string
    field :last_name, :string
    field :locale, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :notes, InkServer.Note
    timestamps()
  end

  # Changesets

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:id, :name, :email, :first_name, :last_name, :locale])
    |> validate_required([:name, :email])
  end

  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :password])
    |> validate_required([:name, :email])
    |> validate_length(:password, min: 12)
    |> put_password_hash()
  end

  def register_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end

  # Queries

  def get(id), do: Repo.get(User, id)

  # Mutations

  def create(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert
  end
end
