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
<%= if @ecto do %>
  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end
<% else %>
  def model do
    quote do
      # Define common model functionality
    end
  end
<% end %>
  def controller do
    quote do
      use Phoenix.Controller<%= if Macro.camelize(@application_name) != @module_name do %>, namespace: <%= @module_name %><% end %>
<%= if @ecto do %>
      alias <%= @module_name %>.Repo
      import Ecto
      import Ecto.Query
<% end %>
      import <%= @module_name %>.Router.Helpers
    end
  end

  def view do
    quote do
      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      import <%= @module_name %>.Router.Helpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
