defmodule :<%= @application_name %>_tasks do
  @moduledoc """
  Nice way to apply migrations inside a released application.

  Example:

      <%= @application_name %>/bin/<%= @application_name %> command <%= @application_name %>_tasks migrate!
  """

  @priv_dir :code.priv_dir(:<%= @application_name %>)

  def migrate! do
    migrations_dir = Path.join([@priv_dir, "repo", "migrations"])

    # Run migrations
    IO.inspect "Running migrations via release options."
    Ecto.Migrator.run(<%= @module_name %>.Repo, migrations_dir, :up, all: true)

    :ok
  end

  def seed! do
    seed_script = Path.join([@priv_dir, "repo", "seeds.exs"])

    # Run seed script
    IO.inspect "Running seeder via release options."
    Code.require_file(seed_script)

    :ok
  end
end
