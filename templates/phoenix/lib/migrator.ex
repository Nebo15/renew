defmodule <%= @module_name %>.Repo.Migrator do
  @moduledoc """
  Nice way to apply migrations inside a released application.

  Just start app with `--migrate` command, be careful when doing this in production.
  """

  require Logger

  @priv_dir "#{:code.priv_dir(:<%= @application_name %>)}"

  def migrate! do
    migrations_dir = Path.join([@priv_dir, "repo", "migrations"])

    # Run migrations
    Logger.warn "Running migrations via release options."
    Logger.warn Ecto.Migrator.run(MyApp.Repo, migrations_dir, :up, all: true)

    :ok
  end

  def seed! do
    seed_script = Path.join([@priv_dir, "repo", "seeds.exs"])

    # Run seed script
    Logger.warn "Running seeder via release options."
    Code.require_file(seed_script)

    :ok
  end
end
