defmodule Ink.Schema do
  use Absinthe.Schema
  import_types Ink.Schema.Types

  query do
    field :posts, list_of(:post) do
      resolve &Ink.PostResolver.all/2
    end

    field :post, type: :post do
      arg :id, non_null(:id)
      resolve &Ink.PostResolver.find/2
    end

    field :users, list_of(:user) do
      resolve &Ink.UserResolver.all/2
    end

    field :user, type: :user do
      arg :id, non_null(:id)
      resolve &Ink.UserResolver.find/2
    end
  end
end
