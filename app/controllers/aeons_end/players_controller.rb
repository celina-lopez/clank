# frozen_string_literal: true

class AeonsEnd::PlayersController < PlayersController
  def show
    # TODO: fix me its in teh wrong place
    @phaser_config = YAML.load_file(Rails.root.join('config', 'game', 'clank', 'phaser.yml'))
  end
end
