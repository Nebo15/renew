# <%= @module_name %>

**TODO: Add description**
<%= if @application_name && !@phoenix do %>
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `<%= @application_name %>` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:<%= @application_name %>, "~> 0.1.0"}]
    end
    ```

  2. Ensure `<%= @application_name %>` is started before your application:

    ```elixir
    def application do
      [applications: [:<%= @application_name %>]]
    end
    ```

If [published on HexDocs](https://hex.pm/docs/tasks#hex_docs), the docs can
be found at [https://hexdocs.pm/<%= @application_name %>](https://hexdocs.pm/<%= @application_name %>)
<% end %>
