# frozen_string_literal: true

class Model::Map
  attr_accessor :tiles

  def initialize
    @tiles = YAML.load_file('config/game/maps.yml')['map_1']
    super
  end

  def self.from_json(json)
    # TODO: fix this
    map = Model::Map.new
    map.tiles = json['tiles']
    map
  end
end
