defmodule Ink.Router do
  use Ink.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Ink do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  forward "/api", Absinthe.Plug,
    schema: Ink.Schema

  if Application.get_env(:ink, :graphiql, false), do:
    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: Ink.Schema

  # Other scopes may use custom stacks.
  # scope "/api", Ink do
  #   pipe_through :api
  # end
end
