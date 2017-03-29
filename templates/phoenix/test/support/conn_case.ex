defmodule <%= @module_name %>.Web.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest<%= if @ecto do %>
      import <%= @module_name %>.Web.Router.Helpers
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      alias <%= @module_name %>.Repo<% end %>

      # The default endpoint for testing
      @endpoint <%= @module_name %>.Web.Endpoint
    end
  end

  setup tags do<%= if @ecto do %>
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(<%= @module_name %>.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(<%= @module_name %>.Repo, {:shared, self()})
    end<% else %>
    _ = tags<% end %>

    conn =
      Phoenix.ConnTest.build_conn()
      |> Plug.Conn.put_req_header("content-type", "application/json")

    {:ok, conn: conn}
  end
end
