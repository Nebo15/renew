PROJECT_DIR=$(git rev-parse --show-toplevel)
PROJECT_NAME=${PROJECT_DIR##*/}

echo "[I] Building a Docker container '${PROJECT_NAME}' from path '${PROJECT_DIR}'.."

docker build -t "${PROJECT_NAME}" -f "${PROJECT_DIR}/Dockerfile" "${PROJECT_DIR}"
