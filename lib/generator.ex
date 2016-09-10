defmodule Renew.Generator do
  import Mix.Generator

  defmacro __using__(_opts) do
    quote do
      import Renew.Generator
    end
  end

  def get_template_source(source) do
    root = Path.expand("../templates", __DIR__)

    source
    |> (&Path.join(root, &1)).()
    |> File.read!
  end

  defmacro load_templates(name, templates) do
    quote bind_quoted: binding do

      tmp = templates
      |> Enum.map(fn ({action, source, destination}) ->
        case action do
          :cp ->
            {action, get_template_source(source), destination}
          :append ->
            {action, get_template_source(source), destination}
          _ ->
            {action, source, destination}
        end
      end)

      Module.put_attribute __MODULE__, name, tmp
    end
  end

  defmacro load_template(name, file) do
    quote bind_quoted: binding do
      Module.put_attribute __MODULE__, name, get_template_source(file)
    end
  end

  def add_config(assigns, add) when is_binary(add) do
    {_, assigns} = Map.get_and_update(assigns, :config, fn config ->
      conf = config <> "\n" <> add
      |> String.trim_trailing

      {config, conf}
    end)

    assigns
  end

  def add_test_config(assigns, add) when is_binary(add) do
    {_, assigns} = Map.get_and_update(assigns, :config_test, fn config_test ->
      conf = config_test <> "\n\n" <> add
      |> String.trim_trailing

      {config_test, conf}
    end)

    assigns
  end

  def add_dev_config(assigns, add) when is_binary(add) do
    {_, assigns} = Map.get_and_update(assigns, :config_dev, fn config_dev ->
      conf = config_dev <> "\n\n" <> add
      |> String.trim_trailing

      {config_dev, conf}
    end)

    assigns
  end

  def add_prod_config(assigns, add) when is_binary(add) do
    {_, assigns} = Map.get_and_update(assigns, :config_prod, fn config_prod ->
      conf = config_prod <> "\n\n" <> add
      |> String.trim_trailing

      {config_prod, conf}
    end)

    assigns
  end

  def add_project_dependencies(assigns, add) when is_list(add) do
    {_, assigns} = Map.get_and_update(assigns, :project_dependencies, fn project_dependencies ->
      {project_dependencies, Enum.uniq(project_dependencies ++ add)}
    end)

    assigns
  end

  def add_project_settings(assigns, add) when is_list(add) do
    {_, assigns} = Map.get_and_update(assigns, :project_settings, fn project_settings ->
      {project_settings, Enum.uniq(project_settings ++ add)}
    end)

    assigns
  end

  def add_project_compilers(assigns, add) when is_list(add) do
    {_, assigns} = Map.get_and_update(assigns, :project_compilers, fn project_compilers ->
      {project_compilers, Enum.uniq(project_compilers ++ add)}
    end)

    assigns
  end

  def add_project_applications(assigns, add) when is_list(add) do
    {_, assigns} = Map.get_and_update(assigns, :project_applications, fn project_applications ->
      {project_applications, Enum.uniq(project_applications ++ add)}
    end)

    assigns
  end

  def set_project_start_module(assigns, {module, params}) when is_binary(module) and is_binary(params) do
    {_, assigns} = Map.get_and_update(assigns, :project_start_module, fn project_start_module ->
      {project_start_module, ",\n     mod: {#{module}, #{params}}"}
    end)

    assigns
  end

  def eval_template(template, assigns) when is_list(assigns) do
    template
    |> EEx.eval_string(assigns: assigns)
  end

  def eval_template(template, %{} = assigns) do
    assigns_map = assigns
    |> assigns_to_eex_map

    eval_template(template, assigns_map)
  end

  def apply_template(files, path, assigns, opts \\ []) do
    # Convert everything to EEx strings
    assigns_map = assigns
    |> assigns_to_eex_map

    # Apply all templates
    for {action, source, destination} <- files do
      target = destination
      |> EEx.eval_string(assigns: assigns_map)
      |> (&Path.join(path, &1)).()

      case action do
        :cp ->
          template = source
          |> eval_template(assigns_map)

          create_file(target, template, opts)
        :append ->
          template = source
          |> eval_template(assigns_map)

          File.write!(target, File.read!(target) <> "\n" <> template)
        :mkdir ->
          File.mkdir_p!(target)
      end

      # Make shell scripts executable
      case Path.extname(target) do
        ".sh" ->
          System.cmd "chmod", ["+x", target]
        _ ->
          :ok
      end
    end
  end

  def assigns_to_eex_map(assigns) do
    assigns
    |> convert_project_dependencies
    |> convert_project_settings
    |> convert_project_applications
    |> convert_project_compilers
    |> Map.to_list
  end

  defp convert_project_dependencies(assigns) do
    {_, assigns} = Map.get_and_update(assigns, :project_dependencies, fn project_dependencies ->
      {project_dependencies, Enum.join(project_dependencies, ",\n     ")}
    end)

    assigns
  end

  defp convert_project_settings(assigns) do
    {_, assigns} = Map.get_and_update(assigns, :project_settings, fn project_settings ->
      t = Enum.join(project_settings, ",\n     ")
      case t do
        "" ->
          {project_settings, ""}
        _ ->
          {project_settings, ",\n     " <> t}
      end
    end)

    assigns
  end

  defp convert_project_applications(assigns) do
    {_, assigns} = Map.get_and_update(assigns, :project_applications, fn project_applications ->
      case project_applications do
        [] ->
          {project_applications, ""}
        _ ->
          {project_applications, ", " <> pretty_join(project_applications)}
      end
    end)

    assigns
  end

  defp pretty_join(enumerable) do
    reduced = Enum.reduce(enumerable, :first, fn
      entry, :first -> entry
      entry, acc ->
        [acc, get_joining_splitter(acc) | entry]
    end)

    if reduced == :first do
      ""
    else
      IO.iodata_to_binary reduced
    end
  end

  defp get_joining_splitter(acc) when is_binary(acc) do
    ", "
  end

  defp get_joining_splitter(acc) do
    case rem(IO.iodata_length(acc), 50) > 40 do
      true ->
        ",\n                    "

      _ ->
        ", "
    end
  end

  defp convert_project_compilers(assigns) do
    {_, assigns} = Map.get_and_update(assigns, :project_compilers, fn project_compilers ->
      {project_compilers, Enum.join(project_compilers, ", ")}
    end)

    assigns
  end
end
