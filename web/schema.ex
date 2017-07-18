defmodule Ink.Schema do
  use Absinthe.Schema
  import_types Ink.Schema.Types

  alias Ink.Resolver

  query do
    field :posts, list_of(:post) do
      resolve &Resolver.Post.all/2
    end

    field :post, type: :post do
      arg :id, non_null(:id)
      resolve &Resolver.Post.find/2
    end

    field :users, list_of(:user) do
      resolve &Resolver.User.all/2
    end

    field :user, type: :user do
      arg :id, non_null(:id)
      resolve &Resolver.User.find/2
    end
  end

  mutation do
    field :create_post, type: :post do
      arg :title, non_null(:string)
      arg :body, non_null(:string)
      arg :user_id, non_null(:integer)

      resolve &Resolver.Post.create/2
    end
  end
end
