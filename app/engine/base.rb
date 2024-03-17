# frozen_string_literal: true

def config_yaml(name)
  YAML.load_file(Rails.root.join('config', 'game', "#{name}.yml"))
end

class Base
  MISC_DECK = %w[companions devices gems items].flat_map { |name| config_yaml(name) }.freeze
  MONSTER_CARDS = config_yaml('monsters').freeze
  RESERVE_CARDS = config_yaml('reserves').freeze
  STARTING_DECK_CARDS = config_yaml('starting_deck').freeze
  CARDS = [MISC_DECK, MONSTER_CARDS, RESERVE_CARDS, STARTING_DECK_CARDS].flatten
  CARD_NAMES = CARDS.map { |c| c['name'] }.freeze

  attr_accessor :gameplay_data

  def initialize(gameplay_data = nil)
    @gameplay_data = gameplay_data
  end

  def current_player
    gameplay_data.current_player
  end
end
