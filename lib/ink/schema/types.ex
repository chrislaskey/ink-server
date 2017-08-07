defmodule Ink.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Ink.Repo

  object :label do
    field :id, :id
    field :name, :string
    field :color, :string
    field :user, :user, resolve: assoc(:user)
  end

  object :note do
    field :uid, :string
    field :secret, :string
    field :title, :string
    field :body, :string
    field :inserted_at, :string
    field :updated_at, :string
    field :user, :user, resolve: assoc(:user)
    field :labels, list_of(:label), resolve: assoc(:labels)
  end

  object :session do
    field :token, :string
    field :token_expiration, :string
    field :user, :user
  end

  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
    field :notes, list_of(:note), resolve: assoc(:notes)
  end
end
