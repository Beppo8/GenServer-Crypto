defmodule Recurring do
  #Client
  def start_link(args) do
    id = Map.get(args, :id)
    GenServer.start_link(Teacher.CoinDataWorker, args, name: id)
  end

  def get_price(id) do
    GenServer.call(id, :price)
  end

  def get_name(id) do
    GenServer.call(id, :name)
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
end
