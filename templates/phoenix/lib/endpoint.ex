defmodule <%= @module_name %>.Endpoint do
  @moduledoc """
  Phoenix Endpoint for <%= @application_name %> application.
  """

  use Phoenix.Endpoint, otp_app: :<%= @application_name %><%= if @ecto do %>

  # Allow acceptance tests to run in concurrent mode
  if Application.get_env(:concurrent_acceptance, :sql_sandbox) do
    plug Phoenix.Ecto.SQL.Sandbox
  end<%= end %>

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_<%= @application_name %>_key",
    signing_salt: "<%= @signing_salt %>"

  plug <%= @module_name %>.Router
end
