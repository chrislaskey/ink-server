defmodule Ink.Schema.Types.User do
  use Absinthe.Schema.Notation

  import Ink.Request, only: [with_login: 1]

  alias Ink.Resolver

  object :user_queries do
  end

  input_object :update_user_params do
    field :name, :string
    field :email, :string
    field :password, :string
  end

  object :user_mutations do
    field :login, type: :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolver.User.login/2
    end

    field :update_user, type: :user do
      arg :id, non_null(:integer)
      arg :user, :update_user_params

      resolve with_login(&Resolver.User.update/2)
    end
  end
end
