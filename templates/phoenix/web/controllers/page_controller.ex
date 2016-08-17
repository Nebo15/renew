defmodule <%= @module_name %>.PageController do
  use <%= @module_name %>.Web, :controller

  def index(conn, _params) do
    render conn, "page.json"
  end
end
