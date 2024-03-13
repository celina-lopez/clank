# frozen_string_literal: true

class Constants
  def config_yaml(name)
    YAML.load_file(Rails.root.join('config', 'game', "#{name}.yml"))
  end
  MISC_DECK = %w[companions devices gems items].flat_map { |name| config_yaml(name) }.freeze
  MONSTER_CARDS = config_yaml('monsters').freeze
  RESERVE_CARDS = config_yaml('reserves').freeze
  STARTING_DECK_CARDS = config_yaml('starting_deck')
  CARD_NAMES = [MISC_DECK, MONSTER_CARDS, RESERVE_CARDS, STARTING_DECK_CARDS].flatten.map { |c| c['name'] }.freeze
end
