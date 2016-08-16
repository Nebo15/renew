defmodule <%= @module_name %>Test do
  use ExUnit.Case
  doctest <%= @module_name %>

  test "the truth" do
    assert 1 + 1 == 2
  end
end
