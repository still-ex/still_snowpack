defmodule Still.Snowpack.MixProject do
  use Mix.Project

  def project do
    [
      app: :still_snowpack,
      description: "Snowpack support for Still",
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:still, "~> 0.5.0"},
      {:still_node, "~> 0.1.0"}
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/still-ex/still_snowpack"},
      files: [
        "LICENSE",
        "mix*",
        "lib/*",
        "priv/package/index*",
        "priv/package/package.json",
        "priv/package/package-lock.json"
      ]
    ]
  end
end
