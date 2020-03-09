defmodule Lifex.Cli do
  @behaviour Ratatouille.App

  alias Ratatouille.Runtime.Subscription

  import Ratatouille.Constants, only: [key: 1]
  import Ratatouille.View

  @spacebar key(:space)

  def init(%{window: %{width: width, height: height}}) do
    %{pause: false, width: width, height: height, generation: 0, pattern: :gosper_gun, board: Lifex.Game.new(width, height, :gosper_gun)}
  end

  def update(model, message) do
    case message do
      {:event, %{key: @spacebar}} ->
        %{model | pause: !model.pause}

      {:event, %{ch: ?n}} ->
        %{model | generation: 0, pattern: :random, board: Lifex.Game.new(model.width, model.height, :random)}

      :tick ->
        case model.pause do
          true -> model
          false -> %{model | generation: model.generation + 1, board: Lifex.Game.next_gen(model.board)}
        end

      _ ->
        model
    end
  end

  def subscribe(_model) do
    Subscription.interval(100, :tick)
  end

  def render(model) do
    population =
      model.board
      |> Map.values()
      |> Enum.sum()

    bottom_bar =
      bar do
        label(content: "[N]ew, [Q]uit, (<space>) Pause, (<arrows>) Change style")
      end

    view(bottom_bar: bottom_bar) do
      panel title: "Lifex, generation #{model.generation}, population #{population}, pattern #{model.pattern} ", height: :fill do
        canvas(
          [height: model.height, width: model.width],
          for {{x, y}, 1} <- model.board do
            canvas_cell(x: x, y: y, color: :green, char:  "\u2022")
          end
        )
      end

      if model.pause do
        overlay do
          panel height: :fill do
            label(content: "PAUSE")
          end
        end
      end
    end
  end
end
