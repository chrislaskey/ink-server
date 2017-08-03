defmodule Ink.Resolver.Label do

  alias Ink.Repo
  alias Ink.Label

  def create(params, _info) do
    %Label{}
    |> Label.changeset(params)
    |> Repo.insert
  end
end
