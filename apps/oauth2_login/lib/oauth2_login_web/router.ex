defmodule OAuth2LoginWeb.Router do
  use OAuth2LoginWeb, :router

  pipeline :graphql do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug OAuth2Login.Plug.CurrentUser
  end

  if Application.get_env(:oauth2_login, :graphiql, false) do
    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: OAuth2Login.GraphQL.Schema
	end

  scope "/" do
    pipe_through :graphql

    forward "/", Absinthe.Plug, schema: OAuth2Login.GraphQL.Schema
  end
end
