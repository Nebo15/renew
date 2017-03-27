defmodule <%= @module_name %>.Web.PageController do
  @moduledoc """
  Sample controller for generated application.
  """
  use <%= @module_name %>.Web, :controller

  action_fallback <%= @module_name %>.Web.FallbackController

  def index(conn, _params) do
    render conn, "page.json"
  end
end
