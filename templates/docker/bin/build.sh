PROJECT_DIR=$(git rev-parse --show-toplevel)
PROJECT_NAME=${PROJECT_DIR##*/}
PROJECT_VERSION=$(sed -n 's/.*@version "\([^"]*\)".*/\1/pg' "${PROJECT_DIR}/mix.exs")

echo "[I] Building a Docker container '${PROJECT_NAME}' (version '${PROJECT_VERSION}') from path '${PROJECT_DIR}'.."

docker build --tag "${PROJECT_NAME}:${PROJECT_VERSION}" \
             --file "${PROJECT_DIR}/Dockerfile" \
             $PROJECT_DIR
