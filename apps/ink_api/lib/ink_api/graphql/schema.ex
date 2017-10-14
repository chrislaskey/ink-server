defmodule InkApi.Schema do
  use Absinthe.Schema

  import_types InkApi.Schema.Types
  import_types InkApi.Schema.Types.Label
  import_types InkApi.Schema.Types.Note
  import_types InkApi.Schema.Types.User

  query do
    import_fields :label_queries
    import_fields :note_queries
  end

  mutation do
    import_fields :label_mutations
    import_fields :note_mutations
    import_fields :user_mutations
  end
end
