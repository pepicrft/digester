defmodule Digester.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :digester,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Digest Elixir primitives",
      package: package(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      name: "digester",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/glossia/digester"}
    ]
  end

  defp docs() do
    [
      main: "Digester",
      extras: ["README.md"],
      source_url: "https://github.com/glossia/digester/",
      source_ref: @version
    ]
  end
end
