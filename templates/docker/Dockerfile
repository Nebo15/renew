# Set the Docker image you want to base your image off.
# I chose this one because it has Elixir preinstalled.
FROM trenpixster/elixir:<%= @minor_version %>

# Maintainers
MAINTAINER Nebo#15 @nebo15

# Install other stable dependencies that don't change often

# Compile app
RUN mkdir /app
WORKDIR /app

# Install Elixir Deps
ADD mix.* ./
ENV MIX_ENV=prod
RUN mix local.rebar --force
RUN mix local.hex --force
RUN mix deps.get

# Generate release
ADD . .
RUN mix release --env=prod

# Clean sources, but save migrations for Ecto.Migrator
RUN if [ -d "priv" ]; then mkdir rel/priv; mv priv/* rel/priv; fi
RUN find . -maxdepth 1 -not -name "rel" -not -name "." -exec rm -rf {} \\;
RUN mv rel/* ./
RUN rm config.exs
RUN rm -r rel

# Allow to read ENV vars for mix configs
ENV REPLACE_OS_VARS=true

# Pre-run hook that allows you to add initialization scripts.
# They should be located in rel/hooks directory, rest of project will be removed on build.
RUN hooks/pre_run.sh

# Runtime config

# Exposes this port from the docker container to the host machine
<%= if !@sup do %># <% end %>EXPOSE 4000

# The command to run when this image starts up
#  You can run it in one of the following ways:
#    Interactive: <%= @app %>/bin/<%= @app %> console
#    Foreground: <%= @app %>/bin/<%= @app %> foreground
#    Daemon: <%= @app %>/bin/<%= @app %> start
CMD <%= @app %>/bin/<%= @app %> <%= @start_cmd %>
