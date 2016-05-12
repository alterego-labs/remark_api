defmodule RemarkApi.Mixfile do
  use Mix.Project

  def project do
    [app: :remark_api,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     elixirc_paths: elixirc_paths(Mix.env),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:exjsx, :logger, :postgrex, :ecto, :ranch, :cowboy, :ex_json_schema, :httpotion],
     mod: {RemarkApi, []}]
  end

  defp deps do
    [
      {:postgrex, "0.11.1"},
      {:ecto, "2.0.0-beta.2"},
      {:cowboy, "1.0.4"},
      {:exjsx, "3.2.0"},
      {:ex_machina, "~> 0.6.1", only: :test},
      {:faker, "~> 0.5", only: :test},
      {:exrm, "~> 1.0.3"},
      {:excoveralls, "~> 0.4", only: :test},
      {:ex_json_schema, "~> 0.3.1"},
      {:httpotion, "~> 2.2.2"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
