defmodule Probuilds.MixProject do
  use Mix.Project

  def project do
    [
      app: :probuilds,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      applications: [:httpotion, :logger, :xandra, :httpoison], 
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:poison, "~>3.1"},
      {:httpotion, "~> 3.1.0"},
      {:mariaex, "~> 0.8.2"},
      {:xandra, "~> 0.10"},
      {:httpoison, "~> 1.4"},
      {:triton, "~> 0.2"},
    ]
  end
end
