defmodule Renew.Generators.CI do
  use Renew.Generator

  load_templates :tpl, [
    {:cp, "ci/bin/hooks/pre-commit.sh",  "bin/hooks/pre-commit.sh"},
    {:cp, "ci/bin/install-git-hooks.sh", "bin/install-git-hooks.sh"},
    {:cp, "ci/config/.credo.exs",        "config/.credo.exs"},
    {:cp, "ci/config/dogma.exs",         "config/dogma.exs"},
    {:cp, "ci/coveralls.json",           "coveralls.json"},
    {:cp, "ci/.travis.yml",              ".travis.yml"},
  ]

  @deps [
    ~S({:benchfella, "~> 0.3", only: [:dev, :test]}),
    ~S({:ex_doc, ">= 0.0.0", only: [:dev, :test]}),
    ~S({:excoveralls, "~> 0.5", only: [:dev, :test]}),
    ~S({:dogma, "> 0.1.0", only: [:dev, :test]}),
    ~S({:credo, ">= 0.4.8", only: [:dev, :test]}),
  ]

  @project_settings [
    ~S(test_coverage: [tool: ExCoveralls]),
    ~S(preferred_cli_env: [coveralls: :test]),
    ~S(docs: [source_ref: "v#\{@version\}", main: "readme", extras: ["README.md"]]),
  ]

  def apply?(assigns) do
    !!assigns[:ci]
  end

  def apply_settings({path, assigns}) do
    assigns = assigns
    |> add_project_dependencies(@deps)
    |> add_project_settings(@project_settings)

    {path, assigns}
  end

  def apply_template({path, assigns}) do
    apply_template @tpl, path, assigns

    {path, assigns}
  end
end
