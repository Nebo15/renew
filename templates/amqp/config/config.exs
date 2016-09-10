# RabbitMQ Config
config :<%= @application_name %>, <%= @module_name %>.AMQP.Connection,
    host: {:system, "MQ_HOST", "localhost"},
    port: {:system, :integer, "MQ_PORT", 5672},
    username: {:system, "MQ_USER", "guest"},
    password: {:system, "MQ_PASSWORD", "guest"},
    virtual_host: {:system, "MQ_VHOST", "/"},
    connection_timeout: {:system, :integer, "MQ_TIMEOUT", 15_000}

# RabbitMQ Consumer config
config :<%= @application_name %>, <%= @module_name %>.AMQP.Consumer,
  connection: <%= @module_name %>.AMQP.Connection,
  queue: [
    name: {:system, "IN_QUEUE_NAME", "<%= @module_name %>.In"},
    error_name:  {:system, "IN_ERROR_QUEUE_NAME", "<%= @module_name %>.In.Errors"},
    durable: {:system, :boolean, "IN_QUEUE_DURABLE", false},
  ],
  qos: [
    prefetch_count: {:system, :integer, "IN_QUEUE_PREFETCH_COUNT", 100},
  ]

# RabbitMQ Producer config
config :<%= @application_name %>, <%= @module_name %>.AMQP.Producer,
  connection: <%= @module_name %>.AMQP.Connection,
  queue: [
    name:        {:system, "OUT_QUEUE_NAME", "<%= @module_name %>.Out"},
    error_name:  {:system, "OUT_ERROR_QUEUE_NAME", "<%= @module_name %>.Out.Errors"},
    routing_key: {:system, "OUT_ROUTING_KEY", ""},
    durable:     {:system, :boolean, "OUT_QUEUE_DURABLE", false},
  ],
  exchange: [
    name:        {:system, "OUT_EXCHANGE_NAME", "<%= @module_name %>.Out"},
    type:        :direct,
    durable:     {:system, :boolean, "OUT_QUEUE_DURABLE", false},
  ]
