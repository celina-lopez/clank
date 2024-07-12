# frozen_string_literal: true

class Clank::GamesController < GamesController
  def new
    # TODO: add game type, aka Clank!
    @game = Game.new
  end

  def show
    # TODO: specific game map
    @game = Game.find(params[:id])
    @phaser_config = YAML.load_file(Rails.root.join('config', 'game', 'phaser.yml'))
  end
end
