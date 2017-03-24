defmodule <%= @module_name %>.Web.Views.Page do
  @moduledoc """
  Sample view for Pages controller.
  """
  use <%= @module_name %>.Web, :view

  def render("page.json", _assigns) do
    %{page: %{detail: "This is page."}}
  end
end
