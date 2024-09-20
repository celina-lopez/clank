# frozen_string_literal: true

class Model::Map
  attr_accessor :tiles

  def initialize(tiles = nil, map_type: 'map_1')
    map_type = 'map_1' if map_type.nil?
    @tiles = tiles || generate_new_map(map_type)
  end

  def generate_new_map(map_type)
    raise NotImplementedError
  end

  def self.from_json(json)
    Model::Map.new(json['tiles'])
  end
end
