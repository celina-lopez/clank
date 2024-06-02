# frozen_string_literal: true

class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def show
    @game = Game.find(params[:id])
  end

  def create
    engine = Engine.new
    gameplay_data = engine.execute(type: 'start_game', value: game_params[:number_of_players])
    game = Game.create!(
      data: JSON.parse(gameplay_data.to_json),
      history: engine.history,
      title: game_params[:title]
    )
    redirect_to game_path(game)
  end

  def update
    game = Game.find(params[:id])
    engine = Engine.new(game.data)
    engine.execute(type: params[:type], value: params[:value])
  end

  private

  def game_params
    params.require(:game).permit(:number_of_players, :title)
  end
end
