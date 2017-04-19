defmodule Renew.Generators.Heroku do
  use Renew.Generator

  load_templates :tpl, [
    {:cp, "heroku/bin/ci/deploy.sh", "bin/ci/deploy.sh"},
    # {:cp, "heroku/app.json",         "app.json"},
  ]

  def apply?(assigns) do
    !!assigns[:heroku] && !!assigns[:ci] && !!assigns[:docker]
  end

  def apply_settings({path, assigns}) do
    {path, assigns}
  end

  def apply_template({path, assigns}) do
    apply_template @tpl, path, assigns

    {path, assigns}
  end
end
