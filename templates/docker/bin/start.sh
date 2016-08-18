PROJECT_DIR=$(git rev-parse --show-toplevel)
PROJECT_NAME=${PROJECT_DIR##*/}
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
