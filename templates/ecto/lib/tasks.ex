defmodule :<%= @application_name %>_tasks do
  @moduledoc """
  Nice way to apply migrations inside a released application.

  Example:

      <%= @application_name %>/bin/<%= @application_name %> command <%= @application_name %>_tasks migrate!
  """

  import Mix.Ecto

  @priv_dir "priv"

  def migrate! do
    # Migrate
    migrations_dir = Path.join([@priv_dir, "repo", "migrations"])

    repo = start_repo(<%= @module_name %>.Repo)

    # Run migrations
    Ecto.Migrator.run(repo, migrations_dir, :up, all: true)

    System.halt(0)
    :init.stop()
  end

  def seed! do
    seed_script = Path.join([@priv_dir, "repo", "seeds.exs"])

    # Run seed script
    repo = start_repo(<%= @module_name %>.Repo)

    Code.require_file(seed_script)

    System.halt(0)
    :init.stop()
  end

  defp start_repo(repo) do
    load_app()
    repo.start_link()
    repo
  end

  defp load_app do
    start_applications([:logger, :postgrex, :ecto])
    :ok = Application.load(:<%= @application_name %>)
  end

  defp start_applications(apps) do
    Enum.each(apps, fn app ->
      {_ , message } = Application.ensure_all_started(app)
    end)
  end
end
