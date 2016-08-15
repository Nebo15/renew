defmodule <%= @mod %>.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [app: :<%= @app %>,
     description: "Add description to your package.",
     package: package,
     version: @version,
     elixir: "~> <%= @version %>",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()<%= @project_settings %>]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger<%= @apps %>]<%= @apps_mod %>]
  end

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
    [<%= @deps %>]
  end

  # Settings for publishing in Hex package manager:
  defp package do
    [contributors: ["Nebo #15"],
     maintainers: ["Nebo #15"],
     licenses: ["LISENSE.md"],
     links: %{github: "https://github.com/Nebo15/<%= @app %>"},
     files: ~w(lib LICENSE.md mix.exs README.md)]
  end
end
