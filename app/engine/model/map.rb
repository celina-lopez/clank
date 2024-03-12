# frozen_string_literal: true

class Model::Map < Model::Base
  attr_accessor :tiles

  def initialize
    @tiles = YAML.load_file('config/game/tiles.yml')['map_1']
    super
  end
end
