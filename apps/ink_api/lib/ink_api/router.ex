defmodule InkApi.Router do
  use InkApi, :router

  pipeline :graphql do
    plug InkServer.Plug.Auth
    plug InkApi.Plug.Context
  end

  if Application.get_env(:ink_api, :graphiql, false), do:
    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: InkApi.GraphQL.Schema

  scope "/" do
    pipe_through :graphql

    forward "/", Absinthe.Plug,
      schema: InkApi.GraphQL.Schema
  end
end
