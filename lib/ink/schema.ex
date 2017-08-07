defmodule Ink.Schema do
  use Absinthe.Schema

  import_types Ink.Schema.Types
  import_types Ink.Schema.Types.Label
  import_types Ink.Schema.Types.Post
  import_types Ink.Schema.Types.User

  query do
    import_fields :label_queries
    import_fields :post_queries
  end

  mutation do
    import_fields :label_mutations
    import_fields :post_mutations
    import_fields :user_mutations
  end
end
