# frozen_string_literal: true

class Clank::PlayersController < PlayersController
  def show
    @phaser_config = YAML.load_file(Rails.root.join('config', 'game', 'phaser.yml'))
  end
end
