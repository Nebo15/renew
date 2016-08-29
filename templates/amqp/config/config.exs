# RabbitMQ Config
config :rbmq, amqp_exchange: "<%= @application_name %>_exchange"
config :rbmq, prefetch_count: 80
config :rbmq, amqp_params: [
  host: "localhost",
  port: 5672,
  username: "guest",
  password: "guest",
  virtual_host: "/",
]
