defmodule Renew.Mixfile do
  use Mix.Project

  @version "0.14.0"

  def project do
    [app: :renew,
     description: "Mix task to create Nebo #15 base mix projects that builds into Docker containers.",
     package: package(),
     version: @version,
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp package do
    [contributors: ["Andrew Dryga"],
     maintainers: ["Andrew Dryga"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/Nebo15/renew"},
     files: ~w(lib LICENSE.md mix.exs README.md)]
  end
end
