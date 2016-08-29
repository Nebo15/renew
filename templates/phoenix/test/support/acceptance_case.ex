defmodule <%= @module_name %>.AcceptanceCase do
  @moduledoc """
  This module defines the test case to be used by
  acceptance tests. It can allow run tests in async when each SQL.Sandbox connection will be
  binded to a specific test.
  """

  use ExUnit.CaseTemplate

  using do
    quote do<%= if @ecto do %>
      import Ecto.Model
      import Ecto.Query, only: [from: 2]<% end %>
      import <%= @module_name %>.Router.Helpers

      alias <%= @module_name %>.Repo

      use HTTPoison.Base

      @endpoint <%= @module_name %>.Endpoint

      # Configure acceptance testing on different host:port
      conf = Application.get_env(:<%= @application_name %>, <%= @module_name %>.Endpoint)
      host = System.get_env("MIX_TEST_HOST") || conf[:http][:host] || "localhost"
      port = System.get_env("MIX_TEST_PORT") || conf[:http][:port] || 4000

      @http_uri "http://#{host}:#{port}/"

      def process_url(url) do
        @http_uri <> url
      end<%= if @ecto do %>

      @metadata_prefix "BeamMetadata"
      defp process_request_headers(headers) do
        meta = Phoenix.Ecto.SQL.Sandbox.metadata_for(<%= @module_name %>.Repo, self())
        encoded = {:v1, meta}
        |> :erlang.term_to_binary
        |> Base.url_encode64

        headers ++ [{"User-Agent", "#{@metadata_prefix} (#{encoded})"}]
      end<% end %>
    end
  end

  setup tags do<%= if @ecto do %>
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(<%= @module_name %>.Repo)

    unless tags[:async] do
       Ecto.Adapters.SQL.Sandbox.mode(<%= @module_name %>.Repo, {:shared, self()})
    end<% else %>
    _ = tags<% end %>
    :ok
  end
end
