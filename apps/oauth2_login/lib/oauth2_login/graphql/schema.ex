defmodule OAuth2Login.GraphQL.Schema do
  use Absinthe.Schema

  import_types OAuth2Login.GraphQL.Types
  import_types OAuth2Login.GraphQL.Types.User

  query do
    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
  end
end
