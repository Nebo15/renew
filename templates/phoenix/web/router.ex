defmodule <%= @module_name %>.Router do
  @moduledoc """
  The router provides a set of macros for generating routes
  that dispatch to specific controllers and actions.
  Those macros are named after HTTP verbs.

  More info at: https://hexdocs.pm/phoenix/Phoenix.Router.html
  """

  use <%= @module_name %>.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :put_secure_browser_headers
    plug Multiverse, gates: [
      "2016-07-31": InitialGate
    ]

    # You can allow JSONP requests by uncommenting this line:
    # plug :allow_jsonp
  end

  scope "/", <%= @module_name %> do
    pipe_through :api

    get "/page", PageController, :index
  end
end
