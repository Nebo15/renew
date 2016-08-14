# <%= @mod %>

**TODO: Add description**
<%= if @app do %>
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `<%= @app %>` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:<%= @app %>, "~> 0.1.0"}]
    end
    ```

  2. Ensure `<%= @app %>` is started before your application:

    ```elixir
    def application do
      [applications: [:<%= @app %>]]
    end
    ```

If [published on HexDocs](https://hex.pm/docs/tasks#hex_docs), the docs can
be found at [https://hexdocs.pm/<%= @app %>](https://hexdocs.pm/<%= @app %>)
<% end %>
