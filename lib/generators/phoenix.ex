defmodule Renew.Generators.Phoenix do
  use Renew.Generator

  load_templates :tpl, [
    {:append, "phoenix/README.md",                     "README.md"},
    {:append, "phoenix/.env",                          ".env"},

    {:cp, "phoenix/lib/web/endpoint.ex",                    "lib/<%= @application_name %>/web/endpoint.ex"},
    {:cp, "phoenix/lib/web/gates/initial_gate.ex",          "lib/<%= @application_name %>/web/gates/initial_gate.ex"},
    {:cp, "phoenix/lib/web/router.ex",                      "lib/<%= @application_name %>/web/router.ex"},
    {:cp, "phoenix/lib/web/web.ex",                         "lib/<%= @application_name %>/web/web.ex"},
    {:cp, "phoenix/lib/web/views/page_view.ex",             "lib/<%= @application_name %>/web/views/page_view.ex"},
    {:cp, "phoenix/lib/web/controllers/page_controller.ex", "lib/<%= @application_name %>/web/controllers/page_controller.ex"},

    {:cp, "phoenix/test/support/conn_case.ex",                                 "test/support/conn_case.ex"},
    {:cp, "phoenix/test/acceptance/web/initial_gate/page_controller_test.exs", "test/acceptance/web/intial_gate/page_controller_test.exs"},
    {:cp, "phoenix/test/unit/web/controllers/page_controller_test.exs",        "test/unit/web/controllers/page_controller_test.exs"},
  ]

  load_template :config_main, 'phoenix/config/config.exs'
  load_template :config_test, 'phoenix/config/test.exs'
  load_template :config_dev,  'phoenix/config/dev.exs'
  load_template :config_prod, 'phoenix/config/prod.exs'

  @compilers [
    ~S(:phoenix),
  ]

  @deps [
    ~S({:cowboy, "~> 1.1"}),
    ~S({:httpoison, "~> 0.11.1"}),
    ~S({:poison, "~> 3.1"}),
    ~S({:phoenix, "~> 1.3.0-rc"}),
    ~S({:multiverse, "~> 0.4.3"}),
    ~S({:eview, "~> 0.10.1"}),
  ]

  @deps_ecto [
    ~S({:phoenix_ecto, "~> 3.2"}),
  ]

  @apps [
    ~S(:cowboy),
    ~S(:httpoison),
    ~S(:poison),
    ~S(:phoenix),
    ~S(:multiverse),
    ~S(:eview),
  ]

  @apps_ecto [
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

  def apply_template({path, assigns}) do
    apply_template @tpl, path, assigns

    {path, assigns}
  end

  defp get_config(assigns) do
    main = @config_main
    |> eval_template(assigns)

    test = @config_test
    |> eval_template(assigns)

    dev = @config_dev
    |> eval_template(assigns)

    prod = @config_prod
    |> eval_template(assigns)

    {main, test, dev, prod}
  end
end
