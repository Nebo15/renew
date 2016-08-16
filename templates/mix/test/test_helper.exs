ExUnit.start()<%= if @ecto do %>
Ecto.Adapters.SQL.Sandbox.mode(<%= @module_name %>.Repo, :manual)<% end %>
