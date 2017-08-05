defmodule Ink.Schema do
  use Absinthe.Schema
  import_types Ink.Schema.Types

  alias Ink.Resolver

  defp add_user_id_to_params(params, %{context: %{current_user: %{id: id}}}), do: Map.put(params, :user_id, id)
  defp add_user_id_to_params(params, _), do: Map.put(params, :user_id, nil)

  defp current_user?(%{context: %{current_user: %{id: id}}}), do: true
  defp current_user?(_), do: false

  defp restrict(resolver) do
    fn (params, info) ->
      case current_user?(info) do
        false -> {:error, "Not Authorized"}
        true -> params
                |> add_user_id_to_params(info)
                |> resolver.(info)
      end
    end
  end

  query do
    field :labels, list_of(:label) do
      resolve restrict &Resolver.Label.all/2
    end

    field :posts, list_of(:post) do
      resolve restrict &Resolver.Post.all/2
    end

    field :post, type: :post do
      arg :uid, non_null(:string)
      resolve restrict &Resolver.Post.find/2
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

      resolve &Resolver.Post.create/2
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
