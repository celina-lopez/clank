# frozen_string_literal: true

def config_yaml(name)
  YAML.load_file(Rails.root.join('config', 'game', "#{name}.yml"))
end

class Base
  COMPANION_CARDS = config_yaml('companions').freeze
  COMPANION_NAMES = COMPANION_CARDS.map { |c| c['name'] }.freeze
  GEM_CARDS = config_yaml('gems').freeze
  GEM_CARD_NAMES = GEM_CARDS.map { |c| c['name'] }.freeze
  MISC_DECK = %w[items].flat_map { |name| config_yaml(name) }.freeze
  DEVICE_CARDS = config_yaml('devices').freeze
  DEVICE_CARD_NAMES = DEVICE_CARDS.map { |c| c['name'] }.freeze
  MONSTER_CARDS = config_yaml('monsters').freeze
  MARKETPLACE = config_yaml('reserves').freeze
  MARKETPLACE_ITEMS = config_yaml('marketplace')['map_1'].freeze
  STARTING_DECK_CARDS = config_yaml('starting_deck').freeze
  STARTING_GAME_CARDS = [GEM_CARDS, COMPANION_CARDS, DEVICE_CARDS, MISC_DECK, MONSTER_CARDS].flatten
  CARDS = [GEM_CARDS, COMPANION_CARDS, MISC_DECK, DEVICE_CARDS, MONSTER_CARDS, MARKETPLACE, STARTING_DECK_CARDS].flatten
  CARD_NAMES = CARDS.map { |c| c['name'] }.freeze
  MINOR_ITEMS = config_yaml('minor_items').freeze
  MAJOR_ITEMS = config_yaml('major_items').freeze
  DEFAULT_MAP = YAML.load_file('config/game/maps.yml')['map_1']

  attr_accessor :gameplay_data

  def initialize(gameplay_data = nil)
    @gameplay_data = gameplay_data
  end

  def current_player
    gameplay_data.players[current_player_index]
  end

  def current_player_index
    gameplay_data&.current_player_index
  end
end
