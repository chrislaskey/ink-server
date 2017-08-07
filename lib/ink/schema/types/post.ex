defmodule Ink.Schema.Types.Post do
  use Absinthe.Schema.Notation

  import Ink.Request, only: [with_login: 1]

  alias Ink.Resolver
  
  object :post_queries do
    field :public_post, type: :post do
      arg :uid, non_null(:string)
      arg :secret, non_null(:string)
      resolve &Resolver.Post.find_by_secret/2
    end

    field :posts, list_of(:post) do
      resolve with_login(&Resolver.Post.all/2)
    end

    field :post, type: :post do
      arg :uid, non_null(:string)
      resolve with_login(&Resolver.Post.find/2)
    end
  end
end
