defmodule DigesterTest do
  use ExUnit.Case
  doctest Digester

  test "hashes strings deterministically" do
    # Given
    first =
      Digester.new() |> Digester.combine("first") |> Digester.combine("second") |> Digester.finalize()

    second =
      Digester.new() |> Digester.combine("first") |> Digester.combine("second") |> Digester.finalize()

    # When/Then
    assert first == second
  end

  test "hashes booleans deterministically" do
    # Given
    first = Digester.new() |> Digester.combine(true) |> Digester.combine(false) |> Digester.finalize()
    second = Digester.new() |> Digester.combine(true) |> Digester.combine(false) |> Digester.finalize()

    # When/Then
    assert first == second
  end

  test "hashes numbers deterministically" do
    # Given
    first = Digester.new() |> Digester.combine(5) |> Digester.combine(22) |> Digester.finalize()
    second = Digester.new() |> Digester.combine(5) |> Digester.combine(22) |> Digester.finalize()

    # When/Then
    assert first == second
  end

  test "hashes lists deterministically" do
    # Given
    first =
      Digester.new()
      |> Digester.combine([5])
      |> Digester.combine([true])
      |> Digester.combine(["foo", "bar"])
      |> Digester.finalize()

    second =
      Digester.new()
      |> Digester.combine([5])
      |> Digester.combine([true])
      |> Digester.combine(["foo", "bar"])
      |> Digester.finalize()

    # When/Then
    assert first == second
  end

  test "hashes tuples deterministically" do
    # Given
    first =
      Digester.new()
      |> Digester.combine({5})
      |> Digester.combine({true})
      |> Digester.combine({"foo", "bar"})
      |> Digester.finalize()

    second =
      Digester.new()
      |> Digester.combine({5})
      |> Digester.combine({true})
      |> Digester.combine({"foo", "bar"})
      |> Digester.finalize()

    # When/Then
    assert first == second
  end

  test "hashes maps deterministically" do
    # Given
    first =
      Digester.new()
      |> Digester.combine(%{foo: "bar", bar: "foo"})
      |> Digester.combine(%{test: "foo", test2: "bar"})
      |> Digester.finalize()

    second =
      Digester.new()
      |> Digester.combine(%{foo: "bar", bar: "foo"})
      |> Digester.combine(%{test: "foo", test2: "bar"})
      |> Digester.finalize()

    # When/Then
    assert first == second
  end
end
