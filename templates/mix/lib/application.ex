defmodule <%= @module_name %> do
  @moduledoc """
  This is an entry point of <%= @application_name %> application.
  """<%= if @sup do %>

  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [<%= if @ecto do %>
      # Start the Ecto repository
      supervisor(<%= @module_name %>.Repo, []),<% end %><%= if @phoenix do %>
      # Start the endpoint when the application starts
      supervisor(<%= @module_name %>.Web.Endpoint, []),<% end %><%= if @amqp do %>
      # Start RabbitMQ supervisor and consumer
      supervisor(<%= @module_name %>.AMQP.Connection, []),
      supervisor(<%= @module_name %>.AMQP.Producer, []),
      supervisor(<%= @module_name %>.AMQP.Consumer, []),<% end %>
      # Starts a worker by calling: <%= @module_name %>.Worker.start_link(arg1, arg2, arg3)
      # worker(<%= @module_name %>.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: <%= @module_name %>.Supervisor]
    Supervisor.start_link(children, opts)
  end<%= if @phoenix do %>

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    <%= @module_name %>.Web.Endpoint.config_change(changed, removed)
    :ok
  end<% end %><% end %>

  # Loads configuration in `:on_init` callbacks and replaces `{:system, ..}` tuples via Confex
  @doc false
  def load_from_system_env(config) do
    {:ok, Confex.process_env(config)}
  end
end
