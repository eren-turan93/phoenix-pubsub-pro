defmodule PhoenixPubSubPro.Store do
  @moduledoc "ETS-backed message store with TTL support."

  use GenServer

  @table :pubsub_pro_messages

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    :ets.new(@table, [:named_table, :ordered_set, :public, read_concurrency: true])
    {:ok, %{}}
  end

  @doc "Store a message for a topic."
  def put(topic, message) do
    key = {topic, System.system_time(:microsecond)}
    :ets.insert(@table, {key, message, DateTime.utc_now()})
  end

  @doc "Get stored messages for a topic."
  def get_messages(topic, limit \\ 100) do
    @table
    |> :ets.match({{topic, :_}, :"$1", :_})
    |> List.flatten()
    |> Enum.take(-limit)
  end

  @doc "Clear all stored messages for a topic."
  def clear(topic) do
    :ets.match_delete(@table, {{topic, :_}, :_, :_})
  end
end
