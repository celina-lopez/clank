# frozen_string_literal: true

class Model::Map
  attr_accessor :tiles

  DEFAULT_MAP = YAML.load_file('config/game/maps.yml')['map_1']

  def initialize(tiles = nil)
    @tiles = tiles || DEFAULT_MAP
  end

  def self.from_json(json)
    Model::Map.new(json['tiles'])
  end
end
