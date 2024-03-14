# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_game, except: %i[new create index]

  def new
    @game = Game.new
  end

  def create
    engine = Engine.new.execute(type: 'start_game', value: '3')
    game = Game.create!(gameplay_data: engine.gameplay_data)
    redirect_to game_path(game)
  end

  def show
    # TODO: fix this
    @player = @game.data.dig('players', 0)
  end

  def update
    engine = Engine.new(@game.data)
    engine.execute(type: params[:type], value: params[:value])
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end
end
