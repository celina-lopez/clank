# frozen_string_literal: true

class Model::Map
  attr_accessor :tiles

  def initialize(tiles = nil)
    @tiles = tiles || generate_new_map
  end

  def generate_new_map # rubocop:disable Metrics/MethodLength
    major_tokens = Base::MAJOR_ITEMS.dup.flat_map do |item|
      item['total'].times.map { item }
    end.shuffle
    minor_tokens = Base::MINOR_ITEMS.dup.shuffle.flat_map do |item|
      item['total'].times.map { item }
    end.shuffle
    Base::DEFAULT_MAP.map do |tile|
      tags = tile.fetch('tags', [])
      if tags.include?('major_item')
        tile['items'] = major_tokens.pop(1)
      elsif tags.include?('minor_item')
        tile['items'] = minor_tokens.pop(2)
      end
      tile
    end
  end

  def self.from_json(json)
    Model::Map.new(json['tiles'])
  end
end
