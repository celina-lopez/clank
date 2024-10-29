# frozen_string_literal: true

class AeonsEnd::GamesController < GamesController
  def show
    @game = Game.find_by_uuid(params[:id])
    @phaser_config = YAML.load_file(Rails.root.join('config', 'game', 'clank', 'phaser.yml'))
  end
end
