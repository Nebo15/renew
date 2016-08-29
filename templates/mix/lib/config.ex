defmodule <%= @module_name %>.Config do
  @moduledoc """
  This module handles fetching values from the config with some additional niceties.
  """

  import Application

  @application_name <%= @application_name %>
  @endpoint <%= @module_name %>.Endpoint

  @doc """
  Fetches key from the default endpoint config, and prepare it with _get/3.
  """
  @spec endpoint(atom, term | nil) :: term
  def endpoint(key, default \\ nil) do
    @application_name
    |> Application.get_env(@endpoint)
    |> Keyword.fetch!(key)
    |> _get(default)
  end

  @doc """
  Fetches key from the default endpoint config, and prepare it with _prepare_map/3.
  """
  @spec endpoint_map(atom, term | nil) :: Keyword.t
  def endpoint_map(key, default \\ nil) do
    @application_name
    |> Application.get_env(@endpoint)
    |> Keyword.fetch!(key)
    |> _prepare_map(default)
  end

  @doc """
  Fetches a value from the config, or from the environment if {:system, "VAR"}
  is provided.
  An optional default value can be provided if desired.
  ## Example
      iex> {test_var, expected_value} = System.get_env |> Enum.take(1) |> List.first
      ...> Application.put_env(:myapp, :test_var, {:system, test_var})
      ...> ^expected_value = #{__MODULE__}.get(:myapp, :test_var)
      ...> :ok
      :ok
      iex> Application.put_env(:myapp, :test_var2, 1)
      ...> 1 = #{__MODULE__}.get(:myapp, :test_var2)
      1
      iex> :default = #{__MODULE__}.get(:myapp, :missing_var, :default)
      :default
  """
  @spec get(atom, atom, term | nil) :: term
  def get(app, key, default \\ nil) when is_atom(app) and is_atom(key) do
    app
    |> Application.get_env(key)
    |> _get(default)
  end

  @doc """
  Same as get/3, but when you has map.
  """
  @spec get_map(atom, atom, term | nil) :: Keyword.t
  def get_map(app, key, default \\ nil) when is_atom(app) and is_atom(key) do
    app
    |> Application.get_env(key)
    |> _prepare_map(default)
  end

  @doc """
  Same as get/3, but returns the result as an integer.
  If the value cannot be converted to an integer, the
  default is returned instead.
  """
  @spec get_integer(atom(), atom(), integer()) :: integer
  def get_integer(app, key, default \\ nil) do
    app
    |> get(key, nil)
    |> _to_integer(default)
  end

  @doc """
  Same as get_integer/3, but when you have integers in the map.
  """
  @spec get_integer_map(atom(), atom(), integer()) :: Keyword.t
  def get_integer_map(app, key, default \\ nil) do
    app
    |> get_map(key, nil)
    |> _prepare_map(default, &_to_integer/2)
  end

  defp _prepare_map(map, default, converter \\ &_get/2) do
    map
    |> Enum.map(fn({key, value}) ->
      {key, converter.(value, default)}
    end)
  end

  defp _get(value, default) do
    case value do
      {:system, env_var} ->
        case System.get_env(env_var) do
          nil -> default
          val -> val
        end
      {:system, env_var, preconfigured_default} ->
        case System.get_env(env_var) do
          nil -> preconfigured_default
          val -> val
        end
      nil ->
        default
      val ->
        val
    end
  end

  defp _to_integer(value, default) do
    case value do
      nil -> default
      n when is_integer(n) -> n
      n ->
        case Integer.parse(n) do
          {i, _} -> i
          :error -> value
        end
    end
  end
end
