defmodule InkApi.Router do
  use InkApi, :router

  pipeline :graphql do
    # TODO
    # plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    # plug Guardian.Plug.LoadResource
    # plug InkApi.Plug.Context
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
