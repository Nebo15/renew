config :<%= @application_name %>, <%= @module_name %>.Endpoint,
  pubsub: [name: <%= @module_name %>.PubSub,
           adapter: Phoenix.PubSub.PG2]
