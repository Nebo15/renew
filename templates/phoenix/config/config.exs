# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
<%= if @has_custom_module_name? do %>
config :<%= @application_name %>,
  namespace: <%= @module_name %>.Web

<% end %># Configures the endpoint
config :<%= @application_name %>, <%= @module_name %>.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "<%= @secret_key_base %>",
  render_errors: [view: EView.Views.PhoenixError, accepts: ~w(json)]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]
