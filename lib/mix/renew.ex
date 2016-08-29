defmodule Mix.Tasks.Renew do
  use Mix.Task

  @shortdoc "Creates a new Elixir project based on Nebo #15 requirements."

  @moduledoc """
  Creates a new Elixir project.
  It expects the path of the project as argument.

      mix renew PATH [--module MODULE] [--app APP] [--umbrella | --ecto --amqp --sup --phoenix] [--ci --docker]

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

  `--ecto-db` - specify the database adapter for ecto.
  Values can be `postgres`, `mysql`. Defaults to `postgres`.

  A `--phoenix` option can be given in order
  to add Phoenix Framework in the generated code skeleton.

  A `--amqp` option can be given in order
  to add Rabbit MQ client (AMQP) in the generated code skeleton.

  ## Examples

      mix renew hello_world

  Is equivalent to:

      mix renew hello_world --module HelloWorld

  To generate an app with supervisor and application callback:

      mix renew hello_world --sup

  Recommended usage:

      mix renew hello_world --ci --docker --sup

  """

  @generator_plugins [
    Renew.Generators.Supervisor,
    Renew.Generators.Ecto,
    Renew.Generators.Phoenix,
    Renew.Generators.Docker,
    Renew.Generators.CI,
    Renew.Generators.AMQP,
  ]

  @switches [
    docker: :boolean,
    ci: :boolean,
    sup: :boolean,
    ecto: :boolean,
    ecto_db: :string,
    amqp: :boolean,
    phoenix: :boolean,
    umbrella: :boolean,
    app: :string,
    module: :string,
  ]

  @spec run(OptionParser.argv) :: :ok
  def run(argv) do
    {opts, argv} = OptionParser.parse!(argv, strict: @switches, aliases: [db: :ecto_db])

    # Normalize opts structure
    opts = opts ++ [
      docker: opts[:docker] || false,
      ci: opts[:ci] || false,
      sup: opts[:phoenix] || opts[:sup] || false, # Phoenix requires supervisor
      ecto: opts[:ecto] || false,
      amqp: opts[:amqp] || false,
      ecto_db: opts[:ecto_db] || "postgres",
      phoenix: opts[:phoenix] || false,
      umbrella: opts[:umbrella] || false
    ]

    case argv do
      [] ->
        Mix.raise ~S(Expected PATH to be given, please use "mix renew PATH")
      [path | _] ->
        # Get module and app names
        dirname = opts[:app] || Path.basename(Path.expand(path))
        app = String.replace(dirname, ["-", "."], "_")
        check_application_name!(app, !!opts[:app])
        mod = opts[:module] || Macro.camelize(app)
        check_module_name_validity!(mod)
        check_module_name_availability!(mod)
        check_directory_existence!(app)

        # Create project path
        File.mkdir_p!(path)

        # Assigns for EEx
        assigns = opts
        |> Enum.into(%{})
        |> Map.merge(%{
            module_name: mod,
            directory_name: dirname,
            application_name: app,
            in_umbrella: in_umbrella?(path),
            elixir_version: get_version(System.version),
            elixir_minor_version: get_minor_version(System.version),
            project_dependencies: [],
            project_applications: [],
            project_start_module: "",
            project_settings: [],
            project_compilers: [],
            config: "",
            config_test: "",
            config_dev: "",
            config_prod: "",
            secret_key_base: random_string(64),
            secret_key_base_prod: random_string(64),
            signing_salt: random_string(8),
            has_custom_module_name?: Macro.camelize(app) != mod
          })

        gens = @generator_plugins
        |> Enum.filter(fn module -> apply(module, :apply?, [assigns]) end)

        # Print begin message
        get_begin_message(assigns)
        |> Mix.shell.info

        # Apply project templates
        {path, assigns}
        |> Renew.Generators.Mix.apply_settings
        |> (&apply_generators_settings(gens, &1)).()
        |> Renew.Generators.Mix.apply_template
        |> (&apply_generators_templates(gens, &1)).()

        # Print success message
        !!opts[:umbrella]
        |> get_success_message(dirname)
        |> String.trim_trailing
        |> Mix.shell.info
    end
  end

  defp apply_generators_settings(generators, {path, assigns}) do
    generators
    |> Enum.reduce({path, assigns}, fn module, acc -> apply(module, :apply_settings, [acc]) end)
  end

  defp apply_generators_templates(generators, {path, assigns}) do
    generators
    |> Enum.reduce({path, assigns}, fn module, acc -> apply(module, :apply_template, [acc]) end)
  end

  defp check_application_name!(name, from_app_flag) do
    unless name =~ ~r/^[a-z][\w_]*$/ do
      extra =
        if !from_app_flag do
          ". The application name is inferred from the path, if you'd like to " <>
          "explicitly name the application then use the `--app APP` option."
        else
          ""
        end

      Mix.raise "Application name must start with a letter and have only lowercase " <>
                "letters, numbers and underscore, got: #{inspect name}" <> extra
    end
  end

  defp check_module_name_validity!(name) do
    unless name =~ ~r/^[A-Z]\w*(\.[A-Z]\w*)*$/ do
      Mix.raise "Module name must be a valid Elixir alias (for example: Foo.Bar), got: #{inspect name}"
    end
  end

  defp check_module_name_availability!(name) do
    name = Module.concat(Elixir, name)
    if Code.ensure_loaded?(name) do
      Mix.raise "Module name #{inspect name} is already taken, please choose another name"
    end
  end

  def check_directory_existence!(name) do
    if File.dir?(name) && !Mix.shell.yes?("The directory #{name} already exists. Are you sure you want to continue?") do
      Mix.raise "Please select another directory for installation."
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

  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.encode64 |> binary_part(0, length)
  end

  defp in_umbrella?(app_path) do
    try do
      umbrella = Path.expand(Path.join [app_path, "..", ".."]) # TODO debug
      File.exists?(Path.join(umbrella, "mix.exs")) &&
        Mix.Project.in_project(:umbrella_check, umbrella, fn _ ->
          path = Mix.Project.config[:apps_path]
          path && Path.expand(path) == Path.join(umbrella, "apps")
        end)
    catch
      _, _ -> false
    end
  end

  defp get_begin_message(%{umbrella: true} = opts) do
    """
    Starting generation of Elixir umbrella project..

    Your settings will include:
      - Distillery release manager<%= if @ci do %>
      - Code Coverage, Analysis and Benchmarking tools
      - Setup for Travis-CI Continuous Integration<% end %><%= if @docker do %>
      - Docker container build config and scripts<% end %>
    """
    |> EEx.eval_string(assigns: Enum.to_list(opts))
  end

  defp get_begin_message(opts) do
    """
    Starting generation of Elixir project..

    Your settings will include:
      - Distillery release manager<%= if @in_umbrella do %>
      - Parent umbrella application bindings<% end %><%= if @sup do %>
      - Application supervisor<% end %><%= if @ecto do %>
      - Ecto database wrapper with <%= @ecto_db %> adapter.<% end %><%= if @phoenix do %>
      - Phoenix Framework
      - Multiverse response compatibility layers<% end %><%= if @amqp do %>
      - AMQP RabbitMQ wrapper<% end %><%= if @ci do %>
      - Code Coverage, Analysis and Benchmarking tools
      - Setup for Travis-CI Continuous Integration
      - Pre-Commit hooks to keep code clean, run `$ ./bin/install-git-hooks.sh`.<% end %><%= if @docker do %>
      - Docker container build config and scripts<% end %>
    """
    |> EEx.eval_string(assigns: Enum.to_list(opts))
  end

  defp get_success_message(true, application_dir) do
    """

    Your umbrella project was created successfully.
    Inside your project, you will find an apps/ directory
    where you can create and host many apps:

        cd #{application_dir}
        cd apps
        mix renew my_app

    Commands like "mix compile" and "mix test" when executed
    in the umbrella project root will automatically run
    for each application in the apps/ directory.
    """
  end

  defp get_success_message(false, application_dir) do
    """

    Your Mix project was created successfully.
    You can use "mix" to compile it, test it, and more:

        cd #{application_dir}
        mix test

    Run "mix help" for more commands.
    """
  end
end
