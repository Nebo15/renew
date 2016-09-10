defmodule <%= @module_name %>.AMQP.Consumer do
  @moduledoc """
  Consumer for AQMP work queue.
  """
  use RBMQ.Consumer,
    otp_app: :<%= @application_name %>,
    connection: <%= @module_name %>.AMQP.Connection

  def consume(payload, [tag: tag, redelivered?: _redelivered]) do
    # Print out received message
    IO.inspect Poison.decode!(payload)

    # Acknowledge task completion
    ack(tag)
  end
end
