defmodule <%= @module_name %>.Repo do
  @moduledoc """
  Repo for Ecto database.

  More info: https://hexdocs.pm/ecto/Ecto.Repo.html
  """
  use Ecto.Repo, otp_app: :<%= @application_name %>
end
