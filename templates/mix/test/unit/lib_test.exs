defmodule <%= @mod %>Test do
  use ExUnit.Case
  doctest <%= @mod %>

  test "the truth" do
    assert 1 + 1 == 2
  end
end
