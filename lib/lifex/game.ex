defmodule Lifex.Game do
  @moduledoc """
  Documentation for `Lifex`.
  """
  @neighbours [{0, 1}, {1, 0}, {1, 1}, {0, -1}, {-1, 0}, {-1, -1}, {1, -1}, {-1, 1}]

  alias Lifex.Game.KnownConfigurations

  def new(x_size, y_size, configuration \\ :random) do
    xs = gen_cols(x_size, y_size)
    ys = gen_rows(y_size, x_size)

    value_fn = case configuration do
      :random ->
        fn k -> {k, :rand.uniform(2) - 1} end
      _ ->
        known_configuration = KnownConfigurations.get_config(configuration)
        fn k -> {k, Map.get(known_configuration, k, 0)} end
    end

    [xs, ys]
    |> Enum.zip()
    |> Enum.map(& value_fn.(&1))
    |> Enum.into(%{})
  end

  def next_gen(board) do
    board
    |> Enum.reduce(%{}, fn {k, v}, new_board ->
      Map.put(new_board, k, new_cell_state(k, v, board))
    end)
  end

  defp gen_cols(size, times) do
    0..(size * times - 1)
    |> Enum.map(&rem(&1, size))
  end

  defp gen_rows(size, times) do
    0..(size - 1)
    |> Enum.to_list()
    |> List.duplicate(times)
    |> List.flatten()
  end

  defp new_cell_state({x, y}, val, board) do
    neighbours =
      @neighbours
      |> Enum.map(fn {x0, y0} -> Map.get(board, {x + x0, y + y0}, 0) end)
      |> Enum.sum()

    case neighbours do
      2 -> val
      3 -> 1
      _ -> 0
    end
  end
end
