defmodule Renew.Generators.AMQP do
  import Renew.Generator

  load_templates :tpl_ci, [
    {:cp, "amqp/bin/init-mq.sh", "bin/init-mq.sh"},
    {:append, "amqp/.env",       ".env"},
  ]

  load_template :config_main, 'amqp/config/config.exs'
  load_template :config_prod, 'amqp/config/prod.exs'

  @deps [
    ~S({:rbmq, "~> 0.2"}),
    ~S({:amqp_client, git: "https://github.com/dsrosario/amqp_client.git", branch: "erlang_otp_19", override: true}),
    ~S({:amqp, "0.1.4"}),
  ]

  @apps [
    ~S(:amqp),
    ~S(:amqp_client),
    ~S(:rbmq),
  ]

  def apply?(assigns) do
    !!assigns[:amqp]
  end

  def apply_settings({path, assigns}) do
    {config, config_prod} = get_config(assigns)

    assigns = assigns
    |> add_project_dependencies(@deps)
    |> add_project_applications(@apps)
    |> add_config(config)
    |> add_prod_config(config_prod)

    {path, assigns}
  end

  def apply_template({path, %{ci: true} = assigns}) do
    apply_template @tpl_ci, path, assigns

    {path, assigns}
  end

  def apply_template({path, assigns}) do
    {path, assigns}
  end

  defp get_config(assigns) do
    config = @config_main
    |> eval_template(assigns)

    config_prod = @config_prod
    |> eval_template(assigns)

    {config, config_prod}
  end
end
