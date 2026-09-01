# ⚗️ phoenix-pubsub-pro

Enhanced PubSub system for Phoenix with message persistence, replay capabilities, and cluster-wide broadcasting.

[![Hex.pm](https://img.shields.io/badge/hex-v0.5.0-blueviolet)](https://hex.pm)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Elixir 1.15+](https://img.shields.io/badge/Elixir-1.15+-4B275F.svg)](https://elixir-lang.org)

## Features

- 📨 **Message persistence** — Store and replay missed messages with ETS/Mnesia
- 🔄 **Replay support** — Consumers can replay from any offset or timestamp
- 🌐 **Cluster-aware** — Automatic node discovery and cross-node broadcasting
- 📊 **Backpressure** — Built-in flow control for slow consumers
- 🔌 **Phoenix integration** — Drop-in replacement for Phoenix.PubSub

## Quick Start

```elixir
# mix.exs
{:phoenix_pubsub_pro, "~> 0.5.0"}
```

```elixir
# config.exs
config :my_app, MyApp.PubSub,
  adapter: PhoenixPubSubPro,
  persistence: :ets,
  retention: :timer.hours(24),
  max_replay_batch: 100

# Publishing
PhoenixPubSubPro.broadcast(MyApp.PubSub, "orders:new", %{
  order_id: "ord_12345",
  total: 99.99,
  items: 3
})

# Subscribing with replay
PhoenixPubSubPro.subscribe(MyApp.PubSub, "orders:new",
  replay_from: :latest,
  handler: fn topic, message ->
    IO.puts("Received on #{topic}: #{inspect(message)}")
  end
)

# Replay missed messages
PhoenixPubSubPro.replay(MyApp.PubSub, "orders:new",
  from: ~U[2024-01-01 00:00:00Z],
  limit: 50
)
```

## Architecture

```
phoenix_pubsub_pro/
├── lib/
│   ├── pubsub_pro.ex           # Main API module
│   ├── broadcaster.ex          # Cluster-wide message dispatch
│   ├── persistence/
│   │   ├── ets_store.ex        # ETS-backed message store
│   │   └── mnesia_store.ex     # Mnesia for distributed persistence
│   ├── replay/
│   │   ├── consumer.ex         # Replay consumer GenServer
│   │   └── cursor.ex           # Offset tracking
│   └── flow_control/
│       └── backpressure.ex     # Rate limiting
└── test/
    └── integration/            # Multi-node cluster tests
```

## License

MIT License
