defmodule InkServer.UserProvider do
  use InkServer.Web, :model

  schema "user_providers" do
    field :type, :string
    field :provider_id, :string
    field :client_id, :string
    field :access_token, :string
    field :expires_at, :integer
    field :refresh_token, :string
    belongs_to :user, InkServer.User
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:type, :provider_id, :client_id, :access_token, :expires_at, :refresh_token, :user_id])
    |> validate_required([:type, :provider_id, :user_id])
  end
end
