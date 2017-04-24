defmodule Renew.Generators.Heroku do
  use Renew.Generator

  load_templates :tpl, [
    {:cp, "heroku/app.json",                "app.json"},
    {:cp, "heroku/Procfile",                "Procfile"},
    {:cp, "heroku/README.md",               "README.md"},
    {:cp, "heroku/bin/ci/deploy.sh",        "bin/ci/deploy.sh"},
    {:cp, "heroku/elixir_buildpack.config", "elixir_buildpack.config"},
  ]

  def apply?(assigns) do
    !!assigns[:heroku]
  end

  def apply_settings({path, assigns}) do
    {path, assigns}
  end

  def apply_template({path, assigns}) do
    apply_template @tpl, path, assigns

    {path, assigns}
  end
end
