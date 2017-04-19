# Environment Variables

This environment variables can be used to configure released docker container at start time.
Also sample `.env` can be used as payload for `docker run` cli.

## General

| VAR_NAME      | Default Value           | Description |
| ------------- | ----------------------- | ----------- |
| ERLANG_COOKIE | `<%= @erlang_cookie %>` | Erlang [distribution cookie](http://erlang.org/doc/reference_manual/distributed.html). **Make sure that default value is changed in production.** |
| LOG_LEVEL     | `info` | Elixir Logger severity level. Possible values: `debug`, `info`, `warn`, `error`. |<%= if @ecto do %>

## Database

Currently there are two options to set DB connections settings.

**By setting a separate value for each option:**

| VAR_NAME      | Default Value | Description |
| ------------- | ------------- | ----------- |
| DB_NAME       | `<%= @application_name %>_dev` | Database name. |
| DB_USER       | `postgres`    | Database user. |
| DB_PASSWORD   | `postgres`    | Database password. |
| DB_HOST       | `travis`      | Database host. |
| DB_PORT       | `5432`        | Database port. |

**By setting a single connection URI:**

| VAR_NAME      | Default Value | Description |
| ------------- | ------------- | ----------- |
| DATABASE_URL  | not set       | Database URI. Example: `postgres://postgres:postgres@travis:5432/<%= @application_name %>_dev` |

If you want to run migrations when container starts, use a `DB_MIGRATE` variable:

| VAR_NAME      | Default Value | Description |
| ------------- | ------------- | ----------- |
| DB_MIGRATE    | `true`        | Migrate database when container starts. |<%= end %><%= if @phoenix do %>

## Phoenix HTTP Endpoint

| VAR_NAME      | Default Value | Description |
| ------------- | ------------- | ----------- |
| PORT          | `4000`        | HTTP host for web app to listen on. |
| HOST          | `localhost`   | HTTP port for web app to listen on. |
| SECRET_KEY    | `<%= @secret_key_base %>` | Phoenix [`:secret_key_base`](https://hexdocs.pm/phoenix/Phoenix.Endpoint.html). **Make sure that default value is changed in production.** |<%= end %>
