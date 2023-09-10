# Digester

`Digester` provides a set of utilities for obtaining **digests** from Elixir primitives. Digests are useful to determine if a value has changed, for example, in a cache.

## Installation

The package can be installed by adding `digester` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:digester, "~> 0.2.0"}
  ]
end
```

## Usage

To obtain a digest from a value or a set of values, you'll have to first create an instance of `Digester`:

```elixir
digester = Digester.new() # Defaults to the SHA256 algorithm

# You can specify the algorithm to use
digester = Digester.new(:sha256)
```

Then, you can use `Digester.combine/2` for every value you'd like to include in the digest:

```elixir
digester = digester
  |> Digester.combine("foo")
  |> Digester.combine(%{bar: "baz"})
```

Remember that **the order** in which you combine values matters, so the following will produce a different digest:

```elixir
digester = digester
  |> Digester.combine(%{bar: "baz"})
  |> Digester.combine("foo")
```

Finally, you can obtain the digest by calling `Digester.finalize/1`:

```elixir
digest = Digester.finalize(digester)
```

`digest` will be a `String` containing the digest of the values you combined.