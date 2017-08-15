defmodule Ink.UserProviderTest do
  use Ink.ModelCase

  alias Ink.UserProvider

  @valid_attrs %{
    type: "facebook",
    provider_id: "user-provider-id",
    client_id: "client-id",
    access_token: "valid-access-token",
    expires_at: 10003418,
    refresh_token: "valid-token-refresh",
    user_id: 1
  }

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserProvider.changeset(%UserProvider{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserProvider.changeset(%UserProvider{}, @invalid_attrs)
    refute changeset.valid?
  end
end
