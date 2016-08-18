use Mix.Releases.Config,
  default_release: :default,
  default_environment: :default

environment :default do
  set dev_mode: false
  set include_erts: false
  set include_src: false
end

release :<%= @application_name %> do
  set version: current_version(:<%= @application_name %>)
end
