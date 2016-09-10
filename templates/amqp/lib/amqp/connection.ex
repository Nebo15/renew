defmodule <%= @module_name %>.AMQP.Connection do
  @moduledoc """
  AQMP connection.
  """
  use RBMQ.Connection,
    otp_app: :<%= @application_name %>
end
