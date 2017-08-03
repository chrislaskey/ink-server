defmodule Ink.LabelTest do
  use Ink.ModelCase

  alias Ink.Label

  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Label.changeset(%Label{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Label.changeset(%Label{}, @invalid_attrs)
    refute changeset.valid?
  end
end
