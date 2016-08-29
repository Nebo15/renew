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
    {:cp, "mix/lib/lib.ex",              "lib/<%= @application_name %>.ex"},
    {:cp, "mix/lib/config.ex",           "lib/<%= @application_name %>/config.ex"},
    {:cp, "mix/test/test_helper.exs",    "test/test_helper.exs"},
    {:cp, "mix/test/unit/lib_test.exs",  "test/unit/<%= @application_name %>_test.exs"},
  ]

  load_templates :tpl_release, [
    {:cp, "mix/rel/config.exs",          "rel/config.exs"},
  ]

  @deps_release [
    ~S({:distillery, "~> 0.9"}),
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

    {path, assigns}
  end

  def apply_settings({path, assigns}) do
    assigns = assigns
    |> add_project_dependencies(@deps_release)

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
