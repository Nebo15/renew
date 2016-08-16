defmodule Renew.Generators.Docker do
  import Renew.Generator

  @tpl [
    {:cp, "docker/.dockerignore",        ".dockerignore"},
    {:cp, "docker/Dockerfile",           "Dockerfile"},
    {:cp, "docker/bin/build.sh",         "bin/build.sh"},
    {:cp, "docker/rel/hooks/pre_run.sh", "rel/hooks/pre_run.sh"},
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
