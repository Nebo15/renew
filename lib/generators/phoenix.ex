defmodule Renew.Generators.Phoenix do
  import Renew.Generator

  @phoenix [
    {:append, "phoenix/README.md",         "README.md"},
  ]

  @phoenix_compilers [
    ~S(:phoenix), # TODO: get rid of sigils
  ]

  @phoenix_deps [

  ]

  @phoenix_apps [
    ~S(:phoenix),
    ~S(:phoenix_pubsub),
    ~S(:phoenix_pubsub),
    ~S(:cowboy),
    :phoenix_ecto #TODO

  ]

  defp apply_phoenix_settings({path, assigns}) do
    case assigns[:phoenix] do
      true ->
        assigns = assigns
        |> add_project_dependencies(@phoenix_deps)
        |> add_project_applications(@phoenix_apps)

        {path, assigns}
      _ ->
        {path, assigns}
    end
  end

  defp apply_phoenix_template({path, assigns}) do
    case assigns[:phoenix] && !assigns[:umbrella] do
      true ->
        apply_template @phoenix, path, assigns
        {path, assigns}
      _ ->
        {path, assigns}
    end
  end
end
