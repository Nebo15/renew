if [ "${DB_MIGRATE}" == "true" ]; then
  echo "[WARNING] Migrating database!"
  ./bin/$APP_NAME command "Elixir.<%= @module_name %>.ReleaseTasks" migrate!
fi;
