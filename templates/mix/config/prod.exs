use Mix.Config

# Configuration for production environment.
# It should read environment variables to follow 12 factor apps convention.

# Do not print debug messages in production
# and handle all other reports by Elixir Logger with JSON back-end
# SASL reports turned off because of their verbosity.
config :logger,
  backends: [LoggerJSON],
  level: :info,
  # handle_sasl_reports: true,
  handle_otp_reports: true

# Sometimes you might want to improve production performance by stripping logger debug calls during compilation
# config :logger,
#   compile_time_purge_level: :info
<%= @config_prod %>
