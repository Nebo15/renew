defmodule Renew.Generators.Supervisor do
  import Renew.Generator

  def apply?(assigns) do
    assigns[:sup] && !assigns[:umbrella]
  end

  def apply_settings({path, assigns}) do
    assigns = assigns
    |> set_project_start_module({assigns[:module_name], "[]"})

    {path, assigns}
  end

  def apply_template({path, assigns}) do
    {path, assigns}
  end
end
