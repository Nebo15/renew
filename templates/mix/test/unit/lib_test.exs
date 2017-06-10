defmodule <%= @module_name %>Test do
  use ExUnit.Case
  doctest <%= @module_name %>

  test "load_from_system_env/1 resolves :system tuples" do
    System.put_env("MY_TEST_ENV", "test_env_value")
    on_exit(fn ->
      System.delete_env("MY_TEST_ENV")
    end)

    assert {:ok, [
      my_conf: "test_env_value",
      other_conf: "persisted"
    ]} == <%= @module_name %>.load_from_system_env([my_conf: {:system, "MY_TEST_ENV"}, other_conf: "persisted"])
  end<%= if @sup do %>

  describe "configure_log_level/1" do
    test "tolerates nil values" do
      assert :ok == <%= @module_name %>.configure_log_level(nil)
    end

    test "raises on invalid LOG_LEVEL" do
      assert_raise ArgumentError, fn ->
        <%= @module_name %>.configure_log_level("super_critical")
      end

      assert_raise ArgumentError, fn ->
        <%= @module_name %>.configure_log_level(:not_a_string)
      end
    end

    test "configures log level" do
      :ok = <%= @module_name %>.configure_log_level("debug")
    end
  end<% end %>
end
