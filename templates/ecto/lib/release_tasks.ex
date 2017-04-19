defmodule <%= @module_name %>.ReleaseTasks do
  @moduledoc """
  Nice way to apply migrations inside a released application.

  Example:

      <%= @application_name %>/bin/<%= @application_name %> command Elixir.<%= @module_name %>.ReleaseTasks migrate!
  """
  @start_apps [
    :logger,
    :logger_json,
    :postgrex,
    :ecto
  ]

  @apps [
    :<%= @application_name %>
  ]

  @repos [
    <%= @module_name %>.Repo
  ]

  def migrate! do
    IO.puts "Loading <%= @application_name %>.."
    # Load the code for <%= @application_name %>, but don't start it
    :ok = Application.load(:<%= @application_name %>)

    IO.puts "Starting dependencies.."
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Start the Repo(s) for <%= @application_name %>
    IO.puts "Starting repos.."
    Enum.each(@repos, &(&1.start_link(pool_size: 1)))

    # Run migrations
    Enum.each(@apps, &run_migrations_for/1)

    # Run the seed script if it exists
    seed_script = seed_path(:<%= @application_name %>)
    if File.exists?(seed_script) do
      IO.puts "Running seed script.."
      Code.eval_file(seed_script)
    end

    # Signal shutdown
    IO.puts "Success!"
    :init.stop()
  end

  def priv_dir(app),
    do: :code.priv_dir(app)

  defp run_migrations_for(app) do
    IO.puts "Running migrations for #{app}"
    Enum.each(@repos, &Ecto.Migrator.run(&1, migrations_path(app), :up, all: true))
  end

  defp migrations_path(app),
    do: Path.join([priv_dir(app), "repo", "migrations"])

  defp seed_path(app),
    do: Path.join([priv_dir(app), "repo", "seeds.exs"])
end
