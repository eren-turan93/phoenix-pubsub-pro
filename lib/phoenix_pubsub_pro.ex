defmodule PhoenixPubSubPro do
  @moduledoc """
  Enhanced PubSub system for Phoenix with message persistence and replay.
  """

  alias PhoenixPubSubPro.Store

  @doc "Broadcast a message to a topic with persistence."
  def broadcast(pubsub, topic, message) do
    # Persist the message
    Store.put(topic, message)

    # Delegate to Phoenix.PubSub
    Phoenix.PubSub.broadcast(pubsub, topic, message)
  end

  @doc "Subscribe to a topic."
  def subscribe(pubsub, topic, opts \\ []) do
    Phoenix.PubSub.subscribe(pubsub, topic)

    # Replay missed messages if requested
    case Keyword.get(opts, :replay_from) do
      nil -> :ok
      :latest -> :ok
      timestamp -> replay(pubsub, topic, from: timestamp)
    end
  end

  @doc "Replay stored messages from a topic."
  def replay(_pubsub, topic, opts \\ []) do
    limit = Keyword.get(opts, :limit, 100)
    Store.get_messages(topic, limit)
  end
end
