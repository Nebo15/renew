defmodule <%= @module_name %>.Web.Endpoint do
  @moduledoc """
  Phoenix Endpoint for <%= @application_name %> application.
  """
  use Phoenix.Endpoint, otp_app: :<%= @application_name %><%= if @ecto do %>

  # Allow acceptance tests to run in concurrent mode
  if Application.get_env(:<%= @application_name %>, :sql_sandbox) do
    plug Phoenix.Ecto.SQL.Sandbox
  end<%= end %>

  plug Plug.RequestId
  plug EView.Plugs.Idempotency
  plug Plug.Logger

  plug EView

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug <%= @module_name %>.Web.Router

  @doc """
  Dynamically loads configuration from the system environment
  on startup.

  It receives the endpoint configuration from the config files
  and must return the updated configuration.
  """
  def load_from_system_env(config) do
    config = Confex.process_env(config)

    unless config[:secret_key_base] do
      raise "Set SECRET_KEY environment variable!"
    end

    {:ok, config}
  end
end
