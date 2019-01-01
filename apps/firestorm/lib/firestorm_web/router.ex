defmodule FirestormWeb.Router do
  use FirestormWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :graphql do
    plug(FirestormWeb.Context)
  end

  scope "/", FirestormWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/graphql" do
    pipe_through(:graphql)

    forward(
      "/",
      Absinthe.Plug,
      schema: FirestormWeb.Schema,
      json_codec: Jason
    )
  end

  # Other scopes may use custom stacks.
  # scope "/api", FirestormWeb do
  #   pipe_through :api
  # end
end
