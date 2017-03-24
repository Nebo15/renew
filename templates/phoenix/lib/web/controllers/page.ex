defmodule <%= @module_name %>.Web.Controllers.Page do
  @moduledoc """
  Sample controller for generated application.
  """
  use <%= @module_name %>.Web, :controller
  alias <%= @module_name %>.Web.Views.Page, as: PageView

  action_fallback <%= @module_name %>.Web.Controllers.Fallback

  def index(conn, _params) do
    render conn, PageView, "page.json"
  end
end
