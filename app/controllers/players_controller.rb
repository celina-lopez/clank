# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action :set_game
  before_action :set_player
  layout 'game'

  def show
    @phaser_config = YAML.load_file(Rails.root.join('config', 'game', 'clank', 'phaser.yml'))
  end

  private

  def set_game
    @game = Game.find_by_uuid(params[:game_id])
  end

  def set_player
    @player = @game.data['players'].find { |player| player['index'] == params[:id].to_i }
  end
end
