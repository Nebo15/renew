defmodule Renew.Generators.Docker do
  use Renew.Generator

  load_templates :tpl, [
    {:cp, "docker/.dockerignore",            ".dockerignore"},
    {:cp, "docker/Dockerfile",               "Dockerfile"},
    {:cp, "docker/bin/build.sh",             "bin/build.sh"},
    {:cp, "docker/bin/start.sh",             "bin/start.sh"},
    {:mkdir, "docker/bin/ci",                "bin/ci"},
    {:cp, "docker/.gitmodules",              ".gitmodules"},
    {:cp, "docker/bin/hooks/pre-run.sh",     "bin/hooks/pre-run.sh"},
  ]

  def apply?(assigns) do
    !!assigns[:docker]
  end

  def apply_settings({path, assigns}) do
    {path, assigns}
  end

  def apply_template({path, assigns}) do
    apply_template @tpl, path, assigns
    {path, assigns}
  end
end
