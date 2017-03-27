defmodule <%= @module_name %>.Web.PageView do
  @moduledoc """
  Sample view for Pages controller.
  """
  use <%= @module_name %>.Web, :view
  alias <%= @module_name %>.Web.PageView

  def render("page.json", _assigns) do
    %{page: %{detail: "This is page."}}
  end
end
