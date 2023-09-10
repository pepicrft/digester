defmodule Digester do
  @moduledoc """
  This module represents a utility to calculate a digest deterministically from a set of values.
  If the order of the elements or their values change, the hash will change.

  This module is useful to support incremental localization based on the hash of the content and
  the context it depends on.
  """
  defstruct [:digestables, :algorithm]

  @type t :: %__MODULE__{}

  @type new_opts :: [{:algorithm, atom()}]

  @doc """
  Creates a new digester with the given options.

  ## Options

  - `:algorithm` - The algorithm to use for hashing. Defaults to `:sha256`.

  ## Examples

      iex> Digester.new()
      %Digester{algorithm: :sha256, digestables: []}
  """
  @spec new(opts :: new_opts) :: __MODULE__.t()
  def new(opts \\ []) do
    algorithm = Keyword.get(opts, :algorithm, :sha256)
    %__MODULE__{digestables: [], algorithm: algorithm}
  end

  @doc """
  Combines the given digestable with the current digester.
  Note that the **order** of the digestables is important. If the same digestables are combined
  but in a different order, the resulting digest will be different.
  """
  @spec combine(digester :: __MODULE__.t(), digestable :: atom | binary | struct | number | tuple | map) :: __MODULE__.t()
  def combine(digester, digestable)

  @spec combine(digester :: __MODULE__.t(), digestable :: binary) :: __MODULE__.t()
  def combine(%__MODULE__{} = digester, digestable) when is_binary(digestable) do
    %{digester | digestables: [hash(digestable, digester.algorithm) | digester.digestables]}
  end

  @spec combine(digester :: __MODULE__.t(), digestable :: atom) :: __MODULE__.t()
  def combine(%__MODULE__{} = digester, digestable) when is_boolean(digestable) do
    boolean_string = if digestable, do: "1", else: "0"
    %{digester | digestables: [hash(boolean_string, digester.algorithm) | digester.digestables]}
  end

  @spec combine(digester :: __MODULE__.t(), digestable :: number) :: __MODULE__.t()
  def combine(%__MODULE__{} = digester, digestable) when is_number(digestable) do
    %{digester | digestables: [hash("#{digestable}", digester.algorithm) | digester.digestables]}
  end

  @spec combine(digester :: __MODULE__.t(), digestable :: list) :: __MODULE__.t()
  def combine(%__MODULE__{} = digester, digestable) when is_list(digestable) do
    digestable |> Enum.reduce(digester, fn digestable, digester -> combine(digester, digestable) end)
  end

  @spec combine(digester :: __MODULE__.t(), digestable :: tuple) :: __MODULE__.t()
  def combine(%__MODULE__{} = digester, digestable) when is_tuple(digestable) do
    combine(digester, digestable |> Tuple.to_list())
  end

  @spec combine(digester :: __MODULE__.t(), digestable :: map) :: __MODULE__.t()
  def combine(%__MODULE__{} = digester, digestable) when is_atom(digestable) do
    combine(digester, digestable |> Atom.to_string())
  end

  @spec combine(digester :: __MODULE__.t(), digestable :: map) :: __MODULE__.t()
  def combine(%__MODULE__{} = digester, digestable) when is_map(digestable) do
    combine(digester, digestable |> Map.to_list() |> Enum.sort())
  end

  @spec combine(digester :: __MODULE__.t(), digestable :: struct) :: __MODULE__.t()
  def combine(%__MODULE__{} = digester, digestable) when is_struct(digestable) do
    combine(digester, digestable |> Map.to_list() |> Enum.sort())
  end

  @doc """
  It finalizes the digester and returns the digest as a string.

  ## Examples

        iex> digester = Digester.new() |> Digester.combine("Hello") |> Digester.combine("World")
        %Digester{algorithm: :sha256, digestables: ["78ae647dc5544d227130a0682a51e30bc7777fbb6d8a8f17007463a3ecd1d524", "185f8db32271fe25f561a6fc938b2e264306ec304eda518007d1764826381969"]}
        iex> Digester.finalize(digester)
        "c79df18bcbce0d9501007f33555ef01b9724f0a986b0dc7d872400bd33053a2e"
  """
  @spec finalize(digester :: __MODULE__.t()) :: String.t()
  def finalize(%__MODULE__{} = digester) do
    digester.digestables |> Enum.join("|") |> hash(digester.algorithm)
  end

  defp hash(value, algorithm) when is_binary(value) do
    :crypto.hash(algorithm, value) |> Base.encode16() |> String.downcase()
  end
end
