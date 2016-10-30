use Mix.Releases.Config,
  default_release: :default,
  default_environment: :default

cookie = :sha256
|> :crypto.hash(System.get_env("ERLANG_COOKIE") || "<%= @erlang_cookie %>")
|> Base.encode64

environment :default do
  set pre_start_hook: "bin/hooks/pre-start.sh"
  set dev_mode: false
  set include_erts: false
  set include_src: false
  set cookie: cookie
end

release :<%= @application_name %> do
  set version: current_version(:<%= @application_name %>)
  set applications: [
    <%= @application_name %>: :permanent
  ]
end
