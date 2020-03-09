defmodule LifexTest do
  use ExUnit.Case
  doctest Lifex

  test "greets the world" do
    assert Lifex.hello() == :world
  end
end
