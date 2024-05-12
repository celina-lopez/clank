# frozen_string_literal: true

class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    # TODO: create frontend for new game
    engine = Engine.new.execute(type: 'start_game', value: '3')
    game = Game.create!(data: engine.gameplay_data, history: engine.history)
    redirect_to game_path(game)
  end

  def update
    game = Game.find(params[:id])
    engine = Engine.new(game.data)
    engine.execute(type: params[:type], value: params[:value])
  end

  private

  def create_game_params
    params.require(:game).permit(:num_of_players)
  end
end
