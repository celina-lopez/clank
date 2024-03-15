# frozen_string_literal: true

class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    engine = Engine.new.execute(type: 'start_game', value: '3')
    game = Game.create!(gameplay_data: engine.gameplay_data)
    redirect_to game_path(game)
  end

  def update
    game = Game.find(params[:id])
    engine = Engine.new(game.data)
    engine.execute(type: params[:type], value: params[:value])
  end
end
