defmodule DigesterTest do
  use ExUnit.Case
  doctest Digester

  test "greets the world" do
    assert Digester.hello() == :world
  end
end
