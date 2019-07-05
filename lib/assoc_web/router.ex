defmodule AssocWeb.Router do
  use AssocWeb, :router

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

  scope "/", AssocWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", AssocWeb do
    get "/themes", ThemeController, :index
    post "/themes/clear", ThemeController, :clear
    post "/themes/multi", ThemeController, :multi
    post "/themes", ThemeController, :add
    delete "/themes/:theme", ThemeController, :delete

    pipe_through :api
  end
end
