defmodule <%= @module_name %>.Web.Gates.Initial do
  @moduledoc """
  Sample compatibility layer for generated application.
  See https://github.com/Nebo15/multiverse for more information.
  """
  @behaviour MultiverseGate
  require Logger

  def mutate_request(%Plug.Conn{} = conn) do
    Logger.debug "Multiverse: InitialGate request mutated."
    # Mutate your request here
    conn
  end

  def mutate_response(%Plug.Conn{} = conn) do
    Logger.debug "Multiverse: InitialGate response mutated."
    # Mutate your response here
    conn
  end
end
