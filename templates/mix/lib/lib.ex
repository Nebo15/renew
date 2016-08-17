defmodule <%= @module_name %> do
  @moduledoc """
  This is an entry point of <%= @application_name %> application.
  """<%= if @sup do %>

  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    <%= if @ecto do %>
    :ok = handle_args!<% end %>
    # Define workers and child supervisors to be supervised
    children = [<%= if @ecto do %>
      # Start the Ecto repository
      supervisor(<%= @module_name %>.Repo, []),<% end %><%= if @phoenix do %>
      # Start the endpoint when the application starts
      supervisor(<%= @module_name %>.Endpoint, []),<% end %>
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
  def config_change(changed, _new, removed) do<%= if @ecto do %>
    :ok = handle_args!
    <% end %>
    <%= @module_name %>.Endpoint.config_change(changed, removed)
    :ok
  end<% end %><% end %><%= if @ecto do %>
  # Nice way to handle migrations on released application
  defp handle_args! do
    switches = [
      migrate: :boolean,
      # To allow running seeder in released application uncomment this switch.
      # Warning! Seeding a production database may result a data loss. Be careful.
      # seed: :boolean,
    ]

    # Any -- arguments will get stripped, so pass them plain and append the flags for convenience
    raw_args = Enum.map(:init.get_plain_arguments, fn a -> "--#{a}" end)
    case OptionParser.parse(raw_args, switches: switches) do
      {opts, _, _} when is_list(opts) ->
        migrate? = get_in(opts, [:migrate]) || false
        seed?    = get_in(opts, [:seed]) || false
        cond do
          migrate? -> <%= @module_name %>.Repo.Migrator.migrate!
          seed?    -> <%= @module_name %>.Repo.Migrator.seed!
          :else    -> :ok
        end
      _ ->
        :ok
    end
  end<% end %>
end
