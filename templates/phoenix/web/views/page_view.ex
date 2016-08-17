defmodule <%= @module_name %>.PageView do
  use <%= @module_name %>.Web, :view

  def render("page.json", _assigns) do
    %{page: %{detail: "This is page."}}
  end
end
