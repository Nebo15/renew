defmodule <%= @module_name %>.AMQP.Producer do
  @moduledoc """
  Producer for AQMP work queue.
  """
  use RBMQ.Producer,
    otp_app: :<%= @application_name %>,
    connection: <%= @module_name %>.AMQP.Connection
end
