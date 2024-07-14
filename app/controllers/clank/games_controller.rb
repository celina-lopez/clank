# frozen_string_literal: true

class Clank::GamesController < GamesController
  def show
    # TODO: specific game map
    @game = Game.find_by_uuid(params[:id])
    @phaser_config = YAML.load_file(Rails.root.join('config', 'game', 'phaser.yml'))
  end
end
