# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action :set_game
  before_action :set_player
  layout 'game'

  private

  def set_game
    @game = Game.find(params[:game_id])
  end

  def set_player
    @player = @game.data['players'].find { |player| player['index'] == params[:id].to_i }
  end
end
