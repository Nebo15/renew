# Settings for Ecto.
# Read more here: https://hexdocs.pm/ecto/Ecto.html
config :<%= @app %>, <%= @mod %>.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "ecto_simple",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
