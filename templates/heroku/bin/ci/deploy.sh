#!/bin/bash
# Deploy container to a Heroku.
# You need to specify $HEROKU_API_KEY secret and $HEROKU_APP_NAME in Travis environment before using this script.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${DIR}/ci/release/fetch-project-environment.sh

# Adjust project naming for Heroku
# You may want to set it manually
PROJECT_NAME=${PROJECT_NAME/./-}
HEROKU_APP_NAME=${HEROKU_APP_NAME:=$PROJECT_NAME}

heroku plugins:install heroku-container-registry

echo "Logging in into Heroku"
heroku container:login
docker login --email=_ --username=_ --password=$(heroku auth:token) registry.heroku.com

if [ "${TRAVIS_PULL_REQUEST}" == "false" ]; then
  if [ "${TRAVIS_BRANCH}" == "${RELEASE_BRANCH}" ]; then
    echo "Tagging container to a Heroku CE"
    docker tag "${HEROKU_APP_NAME}:${PROJECT_VERSION}" "registry.heroku.com/${HEROKU_APP_NAME}/web"
  fi;

  if [[ "${MAIN_BRANCHES}" =~ "${TRAVIS_BRANCH}" ]]; then
    echo "Pushing container to a Heroku CE"
    heroku container:push web --app ${HEROKU_APP_NAME}
  fi;
fi;
