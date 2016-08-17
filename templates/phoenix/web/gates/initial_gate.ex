defmodule InitialGate do
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
