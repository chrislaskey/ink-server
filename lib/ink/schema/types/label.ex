defmodule Ink.Schema.Types.Label do
  use Absinthe.Schema.Notation
  
  import Ink.Request, only: [with_login: 1]

  alias Ink.Resolver
  
  object :label_queries do
    field :labels, list_of(:label) do
      resolve with_login(&Resolver.Label.all/2)
    end
  end

  object :label_mutations do
    field :create_label, type: :label do
      arg :name, non_null(:string)
      arg :color, non_null(:string)

      resolve with_login(&Resolver.Label.create/2)
    end
  end
end
