defmodule <%= @module_name %>.PageController do
  @moduledoc """
  Sample controller for generated application.
  """

  use <%= @module_name %>.Web, :controller

  def index(conn, _params) do
    render conn, "page.json"
  end
end
