# frozen_string_literal: true

class Validation
  class TypeUnknown < StandardError; end
  # TODO: fix card mess below
  COMPANION_CARDS = YAML.load_file(Rails.root.join('config', 'game', 'companions.yml'))
  DEVICE_CARDS = YAML.load_file(Rails.root.join('config', 'game', 'devices.yml'))
  GEM_CARDS = YAML.load_file(Rails.root.join('config', 'game', 'gems.yml'))
  ITEM_CARDS = YAML.load_file(Rails.root.join('config', 'game', 'items.yml'))
  MONSTER_CARDS = YAML.load_file(Rails.root.join('config', 'game', 'monsters.yml'))
  RESERVE_CARDS = YAML.load_file(Rails.root.join('config', 'game', 'reserves.yml'))
  STARTING_DECK_CARDS = YAML.load_file(Rails.root.join('config', 'game', 'starting_deck.yml'))
  CARD_NAMES = COMPANION_CARDS.map { |c| c['name'] } +
               DEVICE_CARDS.map { |c| c['name'] } +
               GEM_CARDS.map { |c| c['name'] } +
               ITEM_CARDS.map { |c| c['name'] } +
               MONSTER_CARDS.map { |c| c['name'] } +
               RESERVE_CARDS.map { |c| c['name'] } +
               STARTING_DECK_CARDS.map { |c| c['name'] }
  attr_reader :gameplay_data

  def initialize(gameplay_data)
    @gameplay_data = gameplay_data
  end

  def valid?(type:, value:)
    raise TypeUnknown unless Executeable::ACTIONS.include?(type)

    klass = case type
            when Executeable::PLAYER_ACTIONS.include?(type)
              Validation::Player
            when CARD_NAMES.include?(type)
              Validation::Game
            when Executeable::GAME_ACTIONS.include?(type)
              Validation::Card
            end
    klass.new(gameplay_data, value:, type:).valid?
  end

  def errors
    raise 'Not implemented'
  end
end
