# frozen_string_literal: true

class Clank::Model::Player < Model::Player
  attr_accessor :coins, :rewards, :replace_card_points, :trash_options, :ignore_monster_path, :skip_crystal_cave,
                :discard_number, :moved_to_crystal_cave, :deck, :position
  attr_reader :clank

  STARTING_CLANK_CUBES = { 0 => 3, 1 => 2, 2 => 1 }.tap { |h| h.default = 0 }.freeze
  MAX_HEALTH = 10
  MAX_CLANK = 30
  START_COINS = 7

  def self.from_json(json)
    new(
      json['index'],
      position: Clank::Model::Position.from_json(json['position']),
      deck: Model::Deck.from_json(json['deck']),
      **json.symbolize_keys.reject { |k, _v| %i[index position deck game_engine].include?(k) }
    )
  end

  def initialize( # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    index = 0,
    clank: nil,
    position: nil,
    deck: nil,
    coins: nil,
    rewards: [],
    trash_options: [],
    ignore_monster_path: false,
    skip_crystal_cave: false,
    discard_number: 0,
    moved_to_crystal_cave: false,
    replace_card_points: 0,
    **kwargs
  )
    super
    @position = position || Clank::Model::Position.new
    @deck = deck || Model::Deck.new(Clank::Base::STARTING_DECK_CARDS)
    @clank = clank || STARTING_CLANK_CUBES[index]
    @coins = coins || START_COINS
    @rewards = rewards || []
    @trash_options = trash_options || []
    @ignore_monster_path = ignore_monster_path || false
    @skip_crystal_cave = skip_crystal_cave || false
    @discard_number = discard_number || 0
    @moved_to_crystal_cave = moved_to_crystal_cave || false
    @replace_card_points = replace_card_points || 0
  end

  def clank=(value)
    @clank = value
    return unless @clank.negative?

    @clank = 0
  end

  def inactive_clank
    clank - MAX_CLANK
  end

  def depths?
    position.depths?
  end

  def artifact?
    inventory.any? { |item| item['is_artifact'] }
  end

  def reset!
    @attack_points = 0
    @move_points = 0
    @skill_points = 0
    @rewards = []
    @trash_options = []
    @ignore_monster_path = false
    @skip_crystal_cave = false
    @discard_number = 0
    @moved_to_crystal_cave = false
    @replace_card_points = 0
  end
end
