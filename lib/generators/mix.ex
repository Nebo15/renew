defmodule Renew.Generators.Mix do
  use Renew.Generator

  load_templates :tpl, [
    {:cp, "mix/README.md",               "README.md"},
    {:cp, "mix/LICENSE.md",              "LICENSE.md"},
    {:cp, "mix/.gitignore",              ".gitignore"},
    {:cp, "mix/.env",                    ".env"},
    {:cp, "mix/bin/hooks/pre-start.sh",  "bin/hooks/pre-start.sh"},
  ]

  load_templates :tpl_mix, [
    {:cp, "mix/config/config.exs",       "config/config.exs"},
    {:cp, "mix/config/dev.exs",          "config/dev.exs"},
    {:cp, "mix/config/test.exs",         "config/test.exs"},
    {:cp, "mix/config/prod.exs",         "config/prod.exs"},
    {:cp, "mix/mix.exs",                 "mix.exs"},
    {:cp, "mix/lib/application.ex",      "lib/<%= @application_name %>/application.ex"},
    {:cp, "mix/test/test_helper.exs",    "test/test_helper.exs"},
    {:cp, "mix/test/unit/lib_test.exs",  "test/unit/<%= @application_name %>_test.exs"},
  ]

  @deps [
    ~S({:confex, "~> 2.0"}),
    ~S({:logger_json, "~> 0.4.0"}),
    ~S({:poison, "~> 3.1"}),
  ]

  @apps [
    ~S(:confex),
    ~S(:runtime_tools),
    ~S(:logger_json),
    ~S(:poison),
  ]

  load_templates :tpl_release, [
    {:cp, "mix/rel/config.exs",            "rel/config.exs"},
    {:cp, "mix/rel/templates/vm.args.eex", "rel/templates/vm.args.eex"},
  ]

  @deps_release [
    ~S({:distillery, "~> 1.2"}),
  ]

  load_templates :tpl_umbrella, [
    {:mkdir, "apps/",                    "apps/"},
    {:cp, "umbrella/config/config.exs",  "config/config.exs"},
    {:cp, "umbrella/mix.exs",            "mix.exs"},
  ]

  @project_settings_in_umbrella [
    ~S(build_path: "../../_build"),
    ~S(config_path: "../../config/config.exs"),
    ~S(deps_path: "../../deps"),
    ~S(lockfile: "../../mix.lock"),
  ]

  def apply_settings({path, %{in_umbrella: true} = assigns}) do
    assigns = assigns
    |> add_project_settings(@project_settings_in_umbrella)
    |> add_project_dependencies(@deps)
    |> add_project_applications(@apps)

    {path, assigns}
  end

  def apply_settings({path, assigns}) do
    assigns = assigns
    |> add_project_dependencies(@deps_release ++ @deps)
    |> add_project_applications(@apps)

    {path, assigns}
  end

  def apply_template({path, %{umbrella: true} = assigns}) do
    apply_template @tpl ++ @tpl_umbrella, path, assigns

    {path, assigns}
  end

  def apply_template({path, %{in_umbrella: true} = assigns}) do
    apply_template @tpl_mix, path, assigns

    {path, assigns}
  end

  def apply_template({path, assigns}) do
    apply_template @tpl ++ @tpl_release ++ @tpl_mix, path, assigns

    {path, assigns}
  end
end
