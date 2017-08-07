defmodule Ink.Schema.Types.Label do
  use Absinthe.Schema.Notation
  
  import Ink.Request, only: [with_login: 1]

  alias Ink.Resolver
  
  object :label_queries do
    field :labels, list_of(:label) do
      resolve with_login(&Resolver.Label.all/2)
    end
  end
end
