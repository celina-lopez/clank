# frozen_string_literal: true

class Clank::Model::Player < Model::Player
  attr_accessor :coins, :inventory, :deck, :position, :rewards, :replace_card_points,
                :skill_points, :trash_options, :ignore_monster_path, :skip_crystal_cave,
                :discard_number, :victory_points, :moved_to_crystal_cave
  attr_reader :clank

  STARTING_CLANK_CUBES = { 0 => 3, 1 => 2, 2 => 1 }.tap { |h| h.default = 0 }.freeze
  MAX_HEALTH = 10
  MAX_CLANK = 30
  START_COINS = 7

  def initialize( # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    index = 0,
    name: nil,
    health: nil,
    clank: nil,
    inventory: [],
    position: nil,
    deck: nil,
    attack_points: 0,
    move_points: 0,
    coins: nil,
    skill_points: 0,
    rewards: [],
    trash_options: [],
    ignore_monster_path: false,
    skip_crystal_cave: false,
    discard_number: 0,
    moved_to_crystal_cave: false,
    victory_points: 0,
    replace_card_points: 0
  )
    @index = index || 0
    @name = name
    @inventory = inventory || []
    @position = position || Model::Position.new
    @deck = deck || Model::Deck.new(Base::STARTING_DECK_CARDS)
    @clank = clank || STARTING_CLANK_CUBES[index]
    @attack_points = attack_points || 0
    @health = health || MAX_HEALTH
    @move_points = move_points || 0
    @coins = coins || START_COINS
    @rewards = rewards || []
    @skill_points = skill_points || 0
    @trash_options = trash_options || []
    @ignore_monster_path = ignore_monster_path || false
    @skip_crystal_cave = skip_crystal_cave || false
    @discard_number = discard_number || 0
    @moved_to_crystal_cave = moved_to_crystal_cave || false
    @victory_points = victory_points
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
