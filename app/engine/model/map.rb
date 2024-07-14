# frozen_string_literal: true

class Model::Map
  attr_accessor :tiles

  def initialize(tiles = nil, map_type: 'map_1')
    map_type = 'map_1' if map_type.nil?
    @tiles = tiles || generate_new_map(map_type)
  end

  def generate_new_map(map_type)
    major_tokens = shuffle_items(Base::MAJOR_ITEMS)
    minor_tokens = shuffle_items(Base::MINOR_ITEMS)
    Base::MAPS[map_type].map do |tile|
      add_items(tile, major_tokens, minor_tokens)
    end
  end

  def self.from_json(json)
    Model::Map.new(json['tiles'])
  end

  private

  def shuffle_items(items)
    items.dup.flat_map do |item|
      item['total'].times.map { item }
    end.shuffle
  end

  def add_items(tile, major_tokens, minor_tokens)
    tags = tile.fetch('tags', [])
    if tags.include?('major_item')
      tile['items'] = major_tokens.pop(1)
    elsif tags.include?('minor_item')
      tile['items'] = minor_tokens.pop(2)
    end
    tile
  end
end
