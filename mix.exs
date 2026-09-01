defmodule PhoenixPubSubPro.MixProject do
  use Mix.Project

  @version "0.5.0"

  def project do
    [
      app: :phoenix_pubsub_pro,
      version: @version,
      elixir: "~> 1.15",
      description: "Enhanced PubSub for Phoenix with message persistence and replay",
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger], mod: {PhoenixPubSubPro.Application, []}]
  end

  defp deps do
    [
      {:phoenix_pubsub, "~> 2.1"},
      {:ex_doc, "~> 0.30", only: :dev, runtime: false}
    ]
  end

  defp package do
    [licenses: ["MIT"], links: %{"GitHub" => "https://github.com/eren-turan93/phoenix-pubsub-pro"}]
  end
end
