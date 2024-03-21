# frozen_string_literal: true

class PlayersController < ApplicationController
  layout 'game'
  before_action :set_game
  before_action :set_player

  def show
    @phaser_config = YAML.load_file(Rails.root.join('config', 'game', 'phaser.yml'))
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end

  def set_player
    # TODO: remove hACK!
    @player = @game.data['players'].find { |player| player['index'] == @game.data['current_player_index'].to_i }
    # @player = @game.data['players'].find { |player| player['index'] == params[:id].to_i }
  end
end
