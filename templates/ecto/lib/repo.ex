defmodule <%= @module_name %>.Repo do
  @moduledoc """
  Repo for Ecto database.

  More info: https://hexdocs.pm/ecto/Ecto.Repo.html
  """
  use Ecto.Repo, otp_app: :<%= @application_name %>

  @doc """
  Dynamically loads the repository configuration from the environment variables.
  """
  def init(_, config) do
    url = System.get_env("DATABASE_URL")
    config = if url, do: Ecto.Repo.Supervisor.parse_url(url), else: Confex.process_env(config)

    unless config[:database] do
      raise "Set DB_NAME environment variable!"
    end

    unless config[:username] do
      raise "Set DB_USER environment variable!"
    end

    unless config[:password] do
      raise "Set DB_PASSWORD environment variable!"
    end

    unless config[:hostname] do
      raise "Set DB_HOST environment variable!"
    end

    unless config[:port] do
      raise "Set DB_PORT environment variable!"
    end

    {:ok, config}
  end
end
