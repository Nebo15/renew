defmodule <%= @module_name %>.Repo do
  use Ecto.Repo, otp_app: :<%= @application_name %>
end
