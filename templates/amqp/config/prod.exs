# RabbitMQ config
config :rbmq, amqp_exchange: "${MQ_EXCHANGE}"
config :rbmq, prefetch_count: "${MQ_PREFETCH_COUNT}"
config :rbmq, amqp_params: [
  host: "${MQ_HOST}",
  port: "${MQ_PORT}",
  username: "${MQ_USER}",
  password: "${MQ_PASSWORD}",
  virtual_host: "${MQ_VHOST}",
]
