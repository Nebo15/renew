PROJECT_DIR=$(git rev-parse --show-toplevel)
PROJECT_NAME=${PROJECT_DIR##*/}
# TODO extract version and add it to tag

echo "[I] Building a Docker container '${PROJECT_NAME}' from path '${PROJECT_DIR}'.."

docker build --tag "${PROJECT_NAME}:0.1.0" \
             --file "${PROJECT_DIR}/Dockerfile" \
             $PROJECT_DIR
