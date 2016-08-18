# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
<%= if Macro.camelize(@application_name) != @module_name || @ecto do %>
config :<%= @application_name %><%= if Macro.camelize(@application_name) != @module_name do %>,
  namespace: <%= @module_name %><% end %><%= if @ecto do %>,
  ecto_repos: [<%= @module_name %>.Repo]<% end %>

<% end %># Configures the endpoint
config :<%= @application_name %>, <%= @module_name %>.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "<%= @secret_key_base %>",
  render_errors: [view: <%= @module_name %>.ErrorView, accepts: ~w(json)]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]
