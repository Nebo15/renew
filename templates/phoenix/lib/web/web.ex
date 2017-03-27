defmodule <%= @module_name %>.Web do
  @moduledoc """
  A module defining __using__ hooks for controllers,
  views and so on.

  This can be used in your application as:

      use <%= @module_name %>.Web, :controller
      use <%= @module_name %>.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def controller do
    quote do
      use Phoenix.Controller<%= if @has_custom_module_name? do %>, namespace: <%= @module_name %>.Web<% end %>
      import Plug.Conn
    end
  end

  def view do
    quote do
      # Import convenience functions from controllers
      import Phoenix.View
      import Phoenix.Controller, only: [view_module: 1]
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
