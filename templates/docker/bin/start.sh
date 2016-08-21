#!/bin/bash

# This script starts a local Docker container with created image.

# Find mix.exs inside project tree.
# This allows to call bash scripts within any folder inside project.
PROJECT_DIR=$(git rev-parse --show-toplevel)
if [ ! -f "${PROJECT_DIR}/mix.exs" ]; then
    echo "[E] Can't find '${PROJECT_DIR}/mix.exs'."
    echo "    Check that you run this script inside git repo or init a new one in project root."
fi

# Extract project name and version from mix.exs
PROJECT_NAME=$(sed -n 's/.*app: :\([^, ]*\).*/\1/pg' "${PROJECT_DIR}/mix.exs")
PROJECT_VERSION=$(sed -n 's/.*@version "\([^"]*\)".*/\1/pg' "${PROJECT_DIR}/mix.exs")
echo "[I] Starting a Docker container '${PROJECT_NAME}' (version '${PROJECT_VERSION}') from path '${PROJECT_DIR}'.."

<%= if @sup do %>docker run -p 4000:4000 \
       --env-file .env \
       -d \
       --name ${PROJECT_NAME} \
       "${PROJECT_NAME}:${PROJECT_VERSION}"
<% else %>docker run -p 4000:4000 \
       --env-file .env \
       --rm \
       --name ${PROJECT_NAME} \
       -i -t "${PROJECT_NAME}:${PROJECT_VERSION}"
<% end %>
