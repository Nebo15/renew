PROJECT_DIR=$(git rev-parse --show-toplevel)
PROJECT_NAME=${PROJECT_DIR##*/}

echo "[I] Starting a Docker container '${PROJECT_NAME}' from path '${PROJECT_DIR}'.."

<%= if @sup do %>docker run -p 4000 \
       --env-file .env \
       -d \
       --name ${PROJECT_NAME} \
       ${PROJECT_NAME}
<% else %>docker run -p 4000 \
       --env-file .env \
       --rm \
       --name ${PROJECT_NAME} \
       -i -t ${PROJECT_NAME}
<% end %>
