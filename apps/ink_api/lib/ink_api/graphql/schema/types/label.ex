defmodule InkApi.Schema.Types.Label do
  use Absinthe.Schema.Notation
  
  import InkApi.Request, only: [with_login: 1]

  alias InkApi.Resolver
  
  object :label_queries do
    field :labels, list_of(:label) do
      resolve with_login(&Resolver.Label.all/2)
    end

    field :label, type: :label do
      arg :id, non_null(:string)

      resolve with_login(&Resolver.Label.find/2)
    end
  end

  input_object :update_label_params do
    field :color, non_null(:string)
    field :name, non_null(:string)
  end

  object :label_mutations do
    field :create_label, type: :label do
      arg :name, non_null(:string)
      arg :color, non_null(:string)

      resolve with_login(&Resolver.Label.create/2)
    end

    field :update_label, type: :label do
      arg :id, non_null(:string)
      arg :label, :update_label_params

      resolve with_login(&Resolver.Label.update/2)
    end

    field :delete_label, type: :label do
      arg :id, non_null(:string)

      resolve with_login(&Resolver.Label.delete/2)
    end
  end
end
