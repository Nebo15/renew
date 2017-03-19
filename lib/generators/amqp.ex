defmodule Renew.Generators.AMQP do
  import Renew.Generator

  load_templates :tpl_amqp, [
    {:cp, "amqp/bin/ci/init-mq.sh",      "bin/ci/init-mq.sh"},
    {:cp, "amqp/lib/amqp/connection.ex", "lib/amqp/connection.ex"},
    {:cp, "amqp/lib/amqp/producer.ex",   "lib/amqp/producer.ex"},
    {:cp, "amqp/lib/amqp/consumer.ex",   "lib/amqp/consumer.ex"},
    {:append, "amqp/.env",               ".env"},
  ]

  load_template :config_main, 'amqp/config/config.exs'

  @deps [
    ~S({:rbmq, "~> 0.3.0"}),
    ~S({:poison, "~> 3.1"})
  ]

  @apps [
    ~S(:rbmq),
    ~S(:poison),
  ]

  def apply?(assigns) do
    !!assigns[:amqp]
  end

  def apply_settings({path, assigns}) do
    config = get_config(assigns)

    assigns = assigns
    |> add_project_dependencies(@deps)
    |> add_project_applications(@apps)
    |> add_config(config)

    {path, assigns}
  end

  def apply_template({path, %{amqp: true} = assigns}) do
    apply_template @tpl_amqp, path, assigns

    {path, assigns}
  end

  def apply_template({path, assigns}) do
    {path, assigns}
  end

  defp get_config(assigns) do
    @config_main
    |> eval_template(assigns)
  end
end
