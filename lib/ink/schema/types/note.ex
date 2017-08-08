defmodule Ink.Schema.Types.Note do
  use Absinthe.Schema.Notation

  import Ink.Request, only: [with_login: 1]

  alias Ink.Resolver

  object :note_queries do
    field :public_note, type: :note do
      arg :uid, non_null(:string)
      arg :secret, non_null(:string)

      resolve &Resolver.Note.find_by_secret/2
    end

    field :notes, list_of(:note) do
      resolve with_login(&Resolver.Note.all/2)
    end

    field :note, type: :note do
      arg :uid, non_null(:string)

      resolve with_login(&Resolver.Note.find/2)
    end
  end

  input_object :update_note_params do
    field :title, non_null(:string)
    field :body, non_null(:string)
  end

  object :note_mutations do
    field :create_note, type: :note do
      arg :title, non_null(:string)
      arg :body, non_null(:string)

      resolve with_login(&Resolver.Note.create/2)
    end

    field :update_note, type: :note do
      arg :uid, non_null(:string)
      arg :note, :update_note_params

      resolve with_login(&Resolver.Note.update/2)
    end

    field :delete_note, type: :note do
      arg :uid, non_null(:string)

      resolve with_login(&Resolver.Note.delete/2)
    end

    field :create_note_label, type: :note do
      arg :uid, non_null(:string)
      arg :label_id, non_null(:integer)

      resolve with_login(&Resolver.Note.add_label/2)
    end

    field :delete_note_label, type: :note do
      arg :uid, non_null(:string)
      arg :label_id, non_null(:integer)

      resolve with_login(&Resolver.Note.remove_label/2)
    end
  end
end
