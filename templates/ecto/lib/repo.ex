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
    config = Confex.process_env(config)

    unless config[:secret_key_base] do
      raise "Set DB_NAME environment variable!"
    end

    unless config[:secret_key_base] do
      raise "Set DB_USER environment variable!"
    end

    unless config[:secret_key_base] do
      raise "Set DB_PASSWORD environment variable!"
    end

    unless config[:secret_key_base] do
      raise "Set DB_HOST environment variable!"
    end

    unless config[:secret_key_base] do
      raise "Set DB_PORT environment variable!"
    end

    {:ok, config}
  end
end
