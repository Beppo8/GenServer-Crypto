defmodule Teacher.CoinDataWorker do
  use GenServer

  alias Teacher.CoinData

  #Callbacks
  def init(state) do
    schedule_coin_fetch()
    {:ok, state}
  end

  def handle_call(:price, _from, state) do
    {:reply, state[:price], state}
  end

  def handle_call(:name, _from, state) do
    {:reply, state[:name], state}
  end

  def handle_cast(:update, state) do
    updated_state = state
      |> Map.get(:id)
      |> CoinData.fetch()
      |> update_state(state)

    {:noreply, updated_state}
  end

  def handle_info(:coin_fetch, state) do
    updated_state = state
      |> Map.get(:id)
      |> CoinData.fetch()
      |> update_state(state)



    schedule_coin_fetch()
    {:noreply, updated_state}
  end

  defp update_state(%{"display_name" => name, "price_usd" => price}, existing_state) do
    Map.merge(existing_state, %{name: name, price: price, updated_at: DateTime.utc_now})
  end

  # defp coin_data(id) do
  #   id
  #   |> Atom.to_string()
  #   |> String.upcase()
  #   |> url()
  #   |> HTTPoison.get!()
  #   |> Map.get(:body)
  #   |> Jason.decode!()
  # end

  # defp url(id) do
  #   "http://coincap.io/page/BTC" <> id
  # end

  defp schedule_coin_fetch do
    Process.send_after(self(), :coin_fetch, 15_000)
  end
end
