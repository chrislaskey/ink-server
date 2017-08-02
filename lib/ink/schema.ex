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

    field :user_posts, list_of(:post) do
      resolve &Resolver.Post.all_user_posts/2
    end

    field :users, list_of(:user) do
      resolve &Resolver.User.all/2
    end

    field :user, type: :user do
      arg :id, non_null(:id)
      resolve &Resolver.User.find/2
    end
  end

  input_object :update_post_params do
    field :title, non_null(:string)
    field :body, non_null(:string)
    field :user_id, non_null(:integer)
  end

  input_object :update_user_params do
    field :name, :string
    field :email, :string
    field :password, :string
  end

  mutation do
    field :create_post, type: :post do
      arg :title, non_null(:string)
      arg :body, non_null(:string)
      arg :user_id, non_null(:integer)

      resolve &Resolver.Post.create/2
    end

    field :update_post, type: :post do
      arg :id, non_null(:integer)
      arg :post, :update_post_params

      resolve &Resolver.Post.update/2
    end

    field :delete_post, type: :post do
      arg :id, non_null(:integer)
      resolve &Resolver.Post.delete/2
    end

    field :update_user, type: :user do
      arg :id, non_null(:integer)
      arg :user, :update_user_params

      resolve &Resolver.User.update/2
    end

    field :login, type: :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolver.User.login/2
    end
  end
end