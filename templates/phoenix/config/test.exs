# We don't run a server during test. If one is required,
# you can enable the server option below.
config :<%= @application_name %>, <%= @module_name %>.Web.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Run acceptance test in concurrent mode
config :<%= @application_name %>, sql_sandbox: true
