defmodule Ink.Schema do
  use Absinthe.Schema
  import_types Ink.Schema.Types

  alias Ink.CurrentUser
  alias Ink.Resolver

  defp with_login(resolver) do
    fn (params, info) ->
      case CurrentUser.present?(info) do
        false -> {:error, "Not Authorized"}
        true -> resolver.(params, info)
      end
    end
  end

  query do
    field :labels, list_of(:label) do
      resolve with_login(&Resolver.Label.all/2)
    end

    field :posts, list_of(:post) do
      resolve with_login(&Resolver.Post.all/2)
    end

    field :post, type: :post do
      arg :uid, non_null(:string)
      resolve with_login(&Resolver.Post.find/2)
    end

    field :public_post, type: :post do
      arg :uid, non_null(:string)
      arg :secret, non_null(:string)
      resolve &Resolver.Post.find_by_secret/2
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

      resolve &Resolver.Post.update/2
    end

    field :delete_post, type: :post do
      arg :uid, non_null(:string)
      resolve &Resolver.Post.delete/2
    end

    field :create_post_label, type: :post do
      arg :uid, non_null(:string)
      arg :label_id, non_null(:integer)

      resolve &Resolver.Post.add_label/2
    end

    field :delete_post_label, type: :post do
      arg :uid, non_null(:string)
      arg :label_id, non_null(:integer)

      resolve &Resolver.Post.remove_label/2
    end

    field :update_user, type: :user do
      arg :id, non_null(:integer)
      arg :user, :update_user_params

      resolve &Resolver.User.update/2
    end

    field :create_label, type: :label do
      arg :name, non_null(:string)
      arg :color, non_null(:string)

      resolve &Resolver.Label.create/2
    end
  end
end
