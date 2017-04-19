defmodule Renew.Generators.Docs do
  use Renew.Generator

  load_templates :tpl, [
    {:cp, "docs/docs/ENVIRONMENT.md", "docs/ENVIRONMENT.md"},
    {:cp, "docs/apiary.apib",         "apiary.apib"},
    {:append, "docs/README.md",       "README.md"},
  ]

  def apply?(assigns) do
    !!assigns[:docs]
  end

  def apply_settings({path, assigns}) do
    {path, assigns}
  end

  def apply_template({path, assigns}) do
    apply_template @tpl, path, assigns

    {path, assigns}
  end
end
