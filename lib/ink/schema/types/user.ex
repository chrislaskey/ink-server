defmodule Ink.Schema.Types.User do
  use Absinthe.Schema.Notation

  alias Ink.Resolver
  
  object :user_queries do
    field :users, list_of(:user) do
      resolve &Resolver.User.all/2
    end

    field :user, type: :user do
      arg :id, non_null(:id)
      resolve &Resolver.User.find/2
    end
  end
end
