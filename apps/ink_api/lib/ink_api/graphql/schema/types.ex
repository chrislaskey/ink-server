defmodule InkApi.GraphQL.Schema.Types do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: InkApi.Repo

  object :label do
    field :id, :id
    field :name, :string
    field :color, :string
    field :note_count, :string
    field :user, :user, resolve: assoc(:user)
    field :notes, list_of(:note), resolve: assoc(:notes)
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
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :locale, :string
    field :notes, list_of(:note), resolve: assoc(:notes)
  end
end
