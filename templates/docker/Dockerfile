FROM nebo15/alpine-elixir:latest
MAINTAINER Nebo#15 support@nebo15.com

# Configure environment variables and other settings
ENV MIX_ENV=prod \
    APP_NAME=<%= @application_name %> \
    APP_PORT=4000

WORKDIR ${HOME}

# Required for elixir_make to work, which is used by some very popular libs
RUN apk add --update --no-cache make

# Install and compile project dependencies
COPY mix.* ./
RUN mix do deps.get, deps.compile

# Add project sources
COPY . .

# Compile project for Erlang VM
RUN mix do compile, release --verbose

# Reduce container size
RUN apk del --no-cache make

# Move release to /opt/$APP_NAME
RUN set -e; \
    mkdir -p /var/log && \
    mkdir -p $HOME/priv && \
    mkdir -p $HOME/priv/uploads && \
    mkdir -p /opt/${APP_NAME}/log && \
    mkdir -p /opt/${APP_NAME}/var && \
    mkdir -p /opt/${APP_NAME}/bin/hooks && \
    cp -R $HOME/priv /opt/${APP_NAME}/ && \
    cp -R $HOME/bin/hooks /opt/${APP_NAME}/bin/ && \
    APP_TARBALL=$(find $HOME/_build/$MIX_ENV/rel/${APP_NAME}/releases -maxdepth 2 -name ${APP_NAME}.tar.gz) && \
    cp $APP_TARBALL /opt/${APP_NAME}/ && \
    cd /opt/${APP_NAME} && \
    tar -xzf ${APP_NAME}.tar.gz && \
    rm ${APP_NAME}.tar.gz && \
    rm -rf /opt/app/* && \
    rm -rf /opt/app && \
    chmod -R 777 /opt/${APP_NAME}/priv/uploads && \
    chmod -R 777 /opt/${APP_NAME}/log && \
    chmod -R 777 /opt/${APP_NAME}/releases && \
    chmod -R 777 /opt/${APP_NAME}/var && \
    chmod -R 777 /var/log

# Change user to "default"
USER default

# Allow to read ENV vars for mix configs
ENV REPLACE_OS_VARS=true

# Exposes this port from the docker container to the host machine
<%= if !@phoenix do %># <% end %>EXPOSE ${APP_PORT}

# Change workdir to a released directory
WORKDIR /opt

# Pre-run hook that allows you to add initialization scripts.
# All Docker hooks should be located in bin/hooks directory.
RUN $APP_NAME/bin/hooks/pre-run.sh

# The command to run when this image starts up.<%= if @ecto do %>
# To run migrations on start set DB_MIGRATE=true env when starting container.<% end %>
CMD $APP_NAME/bin/$APP_NAME <%= if @sup do %>foreground<% else %>console<% end %>
