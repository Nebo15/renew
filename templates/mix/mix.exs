defmodule <%= @module_name %>.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [app: :<%= @application_name %>,<%= if !@umbrella do %>
     description: "Add description to your package.",
     package: package(),<% end %>
     version: @version,
     elixir: "~> <%= @elixir_version %>",
     elixirc_paths: elixirc_paths(Mix.env),<%= if @project_compilers do %>
     compilers: [<%= @project_compilers %>] ++ Mix.compilers,<% end %><%= if @in_umbrella do %>
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",<% end %>
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,<%= if @ecto do %>
     aliases: aliases(),<% end %>
     deps: deps()<%= @project_settings %>]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:logger<%= @project_applications %>]<%= @project_start_module %>]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # To depend on another app inside the umbrella:
  #
  #   {:myapp, in_umbrella: true}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [<%= @project_dependencies %>]
  end<%= if !@umbrella do %>

  # Settings for publishing in Hex package manager:
  defp package do
    [contributors: ["Nebo #15"],
     maintainers: ["Nebo #15"],
     licenses: ["LISENSE.md"],
     links: %{github: "<%= @repo %>"},
     files: ~w(lib LICENSE.md mix.exs README.md)]
  end<% end %><%= if @ecto do %>

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test":       ["ecto.create --quiet", "ecto.migrate", "test"]]
  end<% end %>
end
