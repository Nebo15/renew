defmodule Mix.Tasks.Renew do
  use Mix.Task

  import Mix.Generator

  @shortdoc "Creates a new Elixir project based on Nebo #15 requirements."

  @moduledoc """
  Creates a new Elixir project.
  It expects the path of the project as argument.

      mix renew PATH [--module MODULE] [--app APP] [--umbrella | --ecto --aqmp --sup --phoenix] [--ci --docker]

  A project at the given PATH will be created. The
  application name and module name will be retrieved
  from the path, unless `--module` or `--app` is given.

  When you run command from `apps/` path withing umbrella application,
  different project structure will be applied.

  A `--sup` option can be given to generate an OTP application
  skeleton including a supervision tree. Normally an app is
  generated without a supervisor and without the app callback.

  An `--umbrella` option can be given to generate an
  umbrella project. When you add this flag `--ecto`, `--sup`,
  `--amqp`, `--phoenix` options will options be ignored.

  An `--app` option can be given in order to
  name the OTP application for the project.

  A `--module` option can be given in order
  to name the modules in the generated code skeleton.

  A `--docker` option can be given in order
  to add Docker build strategy in the generated code skeleton.

  A `--ci` option can be given in order
  to add CI tools in the generated code skeleton.

  A `--ecto` option can be given in order
  to add Ecto in the generated code skeleton.

  A `--phoenix` option can be given in order
  to add Phoenix Framework in the generated code skeleton.

  A `--amqp` option can be given in order
  to add Rabbit MQ client (AQMP) in the generated code skeleton.

  ## Examples

      mix renew hello_world

  Is equivalent to:

      mix renew hello_world --module HelloWorld

  To generate an app with supervisor and application callback:

      mix renew hello_world --sup

  Recommended usage:

      mix renew hello_world --ci --docker --sup

  """

  @base [
    {:cp, "mix/README.md",               "README.md"},
    {:cp, "mix/LICENSE.md",              "LICENSE.md"},
    {:cp, "mix/.gitignore",              ".gitignore"},
    {:cp, "mix/.env",                    ".env"},
  ]

  @mix [
    {:cp, "mix/config/config.exs",       "config/config.exs"},
    {:cp, "mix/mix.exs",                 "mix.exs"},
    {:cp, "mix/lib/lib.ex",              "lib/<%= @app %>.ex"},
    {:cp, "mix/test/test_helper.exs",    "test/test_helper.exs"},
    {:cp, "mix/test/unit/lib_test.exs",  "test/unit/<%= @app %>_test.exs"},
  ]

  @rel [
    {:cp, "mix/rel/config.exs",          "rel/config.exs"},
  ]

  @rel_deps [
    ~S({:distillery, "~> 0.9"}),
  ]

  @docker [
    {:cp, "docker/.dockerignore",        ".dockerignore"},
    {:cp, "docker/Dockerfile",           "Dockerfile"},
    {:cp, "docker/bin/build.sh",         "bin/build.sh"},
    {:cp, "docker/rel/hooks/pre_run.sh", "rel/hooks/pre_run.sh"},
  ]

  @ci [
    {:cp, "ci/config/.credo.exs",        "config/.credo.exs"},
    {:cp, "ci/config/dogma.exs",         "config/dogma.exs"},
    {:cp, "ci/coveralls.json",           "coveralls.json"},
    {:cp, "ci/.travis.yml",              ".travis.yml"},
  ]

  @ci_deps [
    ~S({:benchfella, "~> 0.3", only: [:dev, :test]}),
    ~S({:ex_doc, ">= 0.0.0", only: [:dev, :test]}),
    ~S({:excoveralls, "~> 0.5", only: [:dev, :test]}),
    ~S({:dogma, "> 0.1.0", only: [:dev, :test]}),
    ~S({:credo, ">= 0.4.8", only: [:dev, :test]}),
  ]

  @ci_proj [
    ~S(test_coverage: [tool: ExCoveralls]),
    ~S(preferred_cli_env: [coveralls: :test]),
    ~S(docs: [source_ref: "v#\{@version\}", main: "readme", extras: ["README.md"]]),
  ]

  @umbrella @base ++ [
    {:mkdir, "apps/",                    "apps/"},
    {:cp, "umbrella/config/config.exs",  "config/config.exs"},
    {:cp, "umbrella/mix.exs",            "mix.exs"},
  ]

  @umbrella_proj [
    ~S(build_path: "../../_build"),
    ~S(config_path: "../../config/config.exs"),
    ~S(deps_path: "../../deps"),
    ~S(lockfile: "../../mix.lock"),
  ]

  @phoenix [

  ]

  @ecto [
    {:cp, "ecto/lib/repo.ex",                   "lib/<%= @app %>/repo.ex"},
    {:cp, "ecto/priv/repo/seeds.exs",           "priv/repo/seeds.exs"},
    {:mkdir, "ecto/priv/repo/migrations/",      "priv/repo/migrations/"},
    {:mkdir, "ecto/test/models/",               "test/models/"},
    {:cp, "ecto/test/model_case.exs",           "test/model_case.exs"},
    {:append, "ecto/config/config.exs",         "config/config.exs"},
  ]

  @ecto_deps [
    ~S({:ecto, "~> 2.0"}),
  ]

  @ecto_apps [
    ~S(:ecto),
  ]

  @amqp [

  ]

  @switches [
    docker: :boolean,
    ci: :boolean,
    sup: :boolean,
    ecto: :boolean,
    amqp: :boolean,
    phoenix: :boolean,
    umbrella: :boolean,
    app: :string,
    module: :string]

  @spec run(OptionParser.argv) :: :ok
  def run(argv) do
    {opts, argv} = OptionParser.parse!(argv, strict: @switches)

    case argv do
      [] ->
        Mix.raise ~S(Expected PATH to be given, please use "mix renew PATH")
      [path | _] ->

        # Get module and app names
        app = opts[:app] || Path.basename(Path.expand(path))
        check_application_name!(app, !!opts[:app])
        mod = opts[:module] || Macro.camelize(app)
        check_mod_name_validity!(mod)
        check_mod_name_availability!(mod)

        # Create project path
        File.mkdir_p!(path)

        # Assigns for EEx
        assigns = opts
        |> Enum.into(%{})
        |> Map.merge(%{
            mod: mod,
            app: app,
            version: get_version(System.version),
            apps_prefix: apps_prefix(!!opts[:umbrella]),
            minor_version: get_minor_version(System.version),
            deps: [],
            apps: [],
            apps_mod: "",
            project_settings: [],
            start_cmd: start_cmd(!!opts[:sup]),
          })

        # Apply project templates
        {path, assigns}
        |> apply_ci_template
        |> apply_docker_template
        |> apply_sup_template
        |> apply_ecto_settings
        |> apply_mix_template
        |> apply_ecto_template

        # Print success message
        !!opts[:umbrella]
        |> get_success_message
        |> String.trim_trailing
        |> Mix.shell.info
    end
  end

  defp apply_mix_template({path, %{umbrella: true} = assigns} = opts) do
    apply_template @umbrella, path, assigns
    opts
  end

  defp apply_mix_template({path, assigns} = opts) do
    case in_umbrella? do
      true ->
        assigns = assigns
        |> add_project_settings(@umbrella_proj)

        apply_template @mix, path, assigns
        {path, assigns}
      _ ->
        assigns = assigns
        |> add_deps(@rel_deps)

        apply_template @base ++ @rel ++ @mix, path, assigns
        opts
    end
  end

  defp apply_sup_template({path, assigns} = opts) do
    case assigns[:sup] && !assigns[:umbrella] do
      true ->
        assigns = assigns
        |> set_project_mod({assigns[:mod], "[]"})

        {path, assigns}
      _ ->
        opts
    end
  end

  defp apply_docker_template({path, assigns} = opts) do
    case assigns[:docker] do
      true ->
        apply_template @docker, path, assigns
        opts
      _ ->
        opts
    end
  end

  defp apply_ci_template({path, assigns}) do
    case assigns[:ci] do
      true ->
        assigns = assigns
        |> add_deps(@ci_deps)
        |> add_project_settings(@ci_proj)

        apply_template @ci, path, assigns
        {path, assigns}
      _ ->
        {path, assigns}
    end
  end

  defp apply_ecto_settings({path, assigns}) do
    case assigns[:ecto] && !assigns[:umbrella] do
      true ->
        assigns = assigns
        |> add_deps(@ecto_deps)
        |> add_project_apps(@ecto_apps)

        {path, assigns}
      _ ->
        {path, assigns}
    end
  end

  defp apply_ecto_template({path, assigns}) do
    case assigns[:ecto] && !assigns[:umbrella] do
      true ->
        apply_template @ecto, path, assigns
        {path, assigns}
      _ ->
        {path, assigns}
    end
  end

  defp check_application_name!(name, from_app_flag) do
    unless name =~ ~r/^[a-z][\w_]*$/ do
      Mix.raise "Application name must start with a letter and have only lowercase " <>
                "letters, numbers and underscore, got: #{inspect name}" <>
                (if !from_app_flag do
                  ". The application name is inferred from the path, if you'd like to " <>
                  "explicitly name the application then use the \"--app APP\" option."
                else
                  ""
                end)
    end
  end

  defp check_mod_name_validity!(name) do
    unless name =~ ~r/^[A-Z]\w*(\.[A-Z]\w*)*$/ do
      Mix.raise "Module name must be a valid Elixir alias (for example: Foo.Bar), got: #{inspect name}"
    end
  end

  defp check_mod_name_availability!(name) do
    name = Module.concat(Elixir, name)
    if Code.ensure_loaded?(name) do
      Mix.raise "Module name #{inspect name} is already taken, please choose another name"
    end
  end

  defp get_minor_version(version) do
    {:ok, version} = Version.parse(version)
    "#{version.major}.#{version.minor}.#{version.patch}"
  end

  defp get_version(version) do
    {:ok, version} = Version.parse(version)
    "#{version.major}.#{version.minor}" <>
      case version.pre do
        [h | _] -> "-#{h}"
        []      -> ""
      end
  end

  defp add_deps(assigns, add) do
    {_, assigns} = Map.get_and_update(assigns, :deps, fn deps ->
      {deps, deps ++ add}
    end)

    assigns
  end

  defp add_project_settings(assigns, add) do
    {_, assigns} = Map.get_and_update(assigns, :project_settings, fn project_settings ->
      {project_settings, project_settings ++ add}
    end)

    assigns
  end

  defp add_project_apps(assigns, add) do
    {_, assigns} = Map.get_and_update(assigns, :apps, fn apps ->
      {apps, apps ++ add}
    end)

    assigns
  end

  defp set_project_mod(assigns, {module, params}) do
    {_, assigns} = Map.get_and_update(assigns, :apps_mod, fn apps_mod ->
      {apps_mod, ",\n     mod: {#{module}, #{params}}"}
    end)

    assigns
  end

  defp apply_template(files, path, assigns, opts \\ []) do
    root = Path.expand("../../templates", __DIR__)

    # Convert assigns to a list that is required by EEx
    {_, assigns} = Map.get_and_update(assigns, :deps, fn deps ->
      {deps, Enum.join(deps, ",\n     ")}
    end)

    # Convert project settings to a list that is required by EEx
    {_, assigns} = Map.get_and_update(assigns, :project_settings, fn project_settings ->
      t = Enum.join(project_settings, ",\n     ")
      case t do
        "" ->
          {project_settings, ""}
        _ ->
          {project_settings, ",\n     " <> t}
      end
    end)

    # Convert depending applications to a list that is required by EEx
    {_, assigns} = Map.get_and_update(assigns, :apps, fn apps ->
      case apps do
        [] ->
          {apps, ""}
        _ ->
          {apps, ", " <> Enum.join(apps, ", ")}
      end
    end)

    assigns_map = Map.to_list(assigns)

    for {format, source, destination} <- files do
      target = destination
      |> EEx.eval_string(assigns: assigns_map)
      |> (&Path.join(path, &1)).()

      case format do
        :cp ->
          template = source
          |> (&Path.join(root, &1)).()
          |> File.read!
          |> EEx.eval_string(assigns: assigns_map)

          create_file(target, template, opts)
        :append ->
          template = source
          |> (&Path.join(root, &1)).()
          |> File.read!
          |> EEx.eval_string(assigns: assigns_map)

          File.write!(target, File.read!(target) <> template)
        :mkdir ->
          File.mkdir_p!(target)
      end

      case Path.extname(target) do
        ".sh" ->
          System.cmd "chmod", ["+x", target]
        _ ->
          :ok
      end
    end
  end

  defp in_umbrella? do
    apps = Path.dirname(File.cwd!) <> "/apps"

    try do
      Mix.Project.in_project(:umbrella_check, "./..", fn _ ->
        path = Mix.Project.config[:apps_path]
        path && Path.expand(path) == apps
      end)
    catch
      _, _ -> false
    end
  end

  defp start_cmd(false) do
    "console"
  end

  defp start_cmd(true) do
    "start"
  end

  defp apps_prefix(false) do
    ""
  end

  defp apps_prefix(true) do
    "../../"
  end

  defp get_success_message(true) do
    """

    Your umbrella project was created successfully.
    Inside your project, you will find an apps/ directory
    where you can create and host many apps:

        cd PROJECT_PATH
        cd apps
        mix renew my_app

    Commands like "mix compile" and "mix test" when executed
    in the umbrella project root will automatically run
    for each application in the apps/ directory.
    """
  end

  defp get_success_message(false) do
    """

    Your Mix project was created successfully.
    You can use "mix" to compile it, test it, and more:

        cd PROJECT_PATH
        mix test

    Run "mix help" for more commands.
    """
  end
end
