defmodule Renew.Generators.Phoenix do
  import Renew.Generator

  @tpl [
    {:append, "phoenix/README.md",                     "README.md"},
    {:append, "phoenix/.env",                          ".env"},
    {:cp, "phoenix/lib/endpoint.ex",                   "lib/<%= @application_name %>/endpoint.ex"},

    {:cp, "phoenix/test/support/conn_case.ex",         "test/support/conn_case.ex"},
    {:cp, "phoenix/test/support/acceptance_case.ex",   "test/support/acceptance_case.ex"},
    {:cp, "phoenix/web/gates/initial_gate.ex",         "web/gates/initial_gate.ex"},
    {:cp, "phoenix/web/router.ex",                     "web/router.ex"},
    {:cp, "phoenix/web/web.ex",                        "web/web.ex"},
    {:cp, "phoenix/web/views/error_view.ex",           "web/views/error_view.ex"},
    {:cp, "phoenix/web/views/page_view.ex",            "web/views/page_view.ex"},
    {:cp, "phoenix/web/views/layout_view.ex",          "web/views/layout_view.ex"},
    {:cp, "phoenix/web/controllers/page_controller.ex",             "web/controllers/page_controller.ex"},
    {:cp, "phoenix/test/acceptance/initial_gate/page_test.exs",     "test/acceptance/intial_gate/page_test.exs"},
    {:cp, "phoenix/test/unit/controllers/page_controller_test.exs", "test/unit/controllers/page_controller_test.exs"},
  ]

  @tpl_ecto [
    {:cp, "phoenix/lib/migrator.ex", "lib/<%= @application_name %>/migrator.ex"},
  ]

  @compilers [
    ~S(:phoenix),
  ]

  @deps [
    ~S({:cowboy, "~> 1.0"}),
    ~S({:httpoison, "~> 0.9.0"}),
    ~S({:poison, "~> 2.0"}),
    ~S({:phoenix, "~> 1.2.0"}),
    ~S({:phoenix_pubsub, "~> 1.0"}),
    ~S({:ex_json_schema, "~> 0.5"}),
    ~S({:timex, "~> 3.0"}),
    ~S({:multiverse, "~> 0.4.1"}),
  ]

  @deps_ecto [
    ~S({:timex_ecto, "~> 3.0"}),
    ~S({:phoenix_ecto, "~> 3.0"}),
  ]

  @apps [
    ~S(:cowboy),
    ~S(:httpoison),
    ~S(:poison),
    ~S(:phoenix),
    ~S(:phoenix_pubsub),
    ~S(:timex),
    ~S(:multiverse),
  ]

  @apps_ecto [
    ~S(:timex_ecto),
    ~S(:phoenix_ecto),
  ]

  def apply?(assigns) do
    assigns[:phoenix] && !assigns[:umbrella]
  end

  def apply_settings({path, assigns}) do
    {config, config_test, config_dev, config_prod} = get_config(assigns)

    assigns = assigns
    |> add_project_dependencies(@deps)
    |> add_project_applications(@apps)
    |> add_project_compilers(@compilers)
    |> add_config(config)
    |> add_test_config(config_test)
    |> add_dev_config(config_dev)
    |> add_prod_config(config_prod)
    |> apply_ecto_settings

    {path, assigns}
  end

  defp apply_ecto_settings(%{ecto: true} = assigns) do
    assigns
    |> add_project_dependencies(@deps_ecto)
    |> add_project_applications(@apps_ecto)
  end

  defp apply_ecto_settings(assigns) do
    assigns
  end

  def apply_template({path, %{ecto: true} = assigns}) do
    apply_template @tpl ++ @tpl_ecto, path, assigns

    {path, assigns}
  end

  def apply_template({path, assigns}) do
    apply_template @tpl, path, assigns

    {path, assigns}
  end

  defp get_config(assigns) do
    main = 'phoenix/config/config.exs'
    |> get_template(assigns)

    test = 'phoenix/config/test.exs'
    |> get_template(assigns)

    dev = 'phoenix/config/dev.exs'
    |> get_template(assigns)

    prod = 'phoenix/config/prod.exs'
    |> get_template(assigns)

    {main, test, dev, prod}
  end
end
