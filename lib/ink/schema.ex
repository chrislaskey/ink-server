defmodule Ink.Schema do
  use Absinthe.Schema

  import_types Ink.Schema.Types
  import_types Ink.Schema.Types.Label
  import_types Ink.Schema.Types.Post
  import_types Ink.Schema.Types.User

  alias Ink.Resolver

  import Ink.Request, only: [with_login: 1]

  query do
    import_fields :label_queries
    import_fields :post_queries
    import_fields :user_queries
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
    field :login, type: :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolver.User.login/2
    end

    field :create_post, type: :post do
      arg :title, non_null(:string)
      arg :body, non_null(:string)
      arg :user_id, non_null(:integer)

      resolve with_login(&Resolver.Post.create/2)
    end

    field :update_post, type: :post do
      arg :uid, non_null(:string)
      arg :post, :update_post_params

      resolve with_login(&Resolver.Post.update/2)
    end

    field :delete_post, type: :post do
      arg :uid, non_null(:string)

      resolve with_login(&Resolver.Post.delete/2)
    end

    field :create_post_label, type: :post do
      arg :uid, non_null(:string)
      arg :label_id, non_null(:integer)

      resolve with_login(&Resolver.Post.add_label/2)
    end

    field :delete_post_label, type: :post do
      arg :uid, non_null(:string)
      arg :label_id, non_null(:integer)

      resolve with_login(&Resolver.Post.remove_label/2)
    end

    field :update_user, type: :user do
      arg :id, non_null(:integer)
      arg :user, :update_user_params

      resolve &Resolver.User.update/2
    end

    field :create_label, type: :label do
      arg :name, non_null(:string)
      arg :color, non_null(:string)

      resolve with_login(&Resolver.Label.create/2)
    end
  end
end
