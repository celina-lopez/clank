# frozen_string_literal: true

class Model::Map
  attr_accessor :tiles

  def initialize(tiles = nil)
    @tiles = tiles || generate_new_map
  end

  def generate_new_map # rubocop:disable Metrics/MethodLength
    major_tokens = BASE::MAJOR_ITEMS.dup.shuffle
    minor_tokens = BASE::MINOR_ITEMS.dup.shuffle
    BASE::DEFAULT_MAP.map do |tile|
      case tile['type']
      when 'major_item'
        tile['items'] = major_tokens.pop(1)
      when 'minor_item'
        tile['items'] = minor_tokens.pop(2)
      end
      tile
    end
  end

  def remove_item(position, item)
    items = tiles.find { |tile| tile['tile'] == position }['items']
    items.delete_at(items.index(item))
  end

  def self.from_json(json)
    Model::Map.new(json['tiles'])
  end
end
