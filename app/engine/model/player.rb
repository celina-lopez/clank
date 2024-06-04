# frozen_string_literal: true

class Model::Player
  attr_accessor :attack_points, :move_points, :teleport, :coins, :inventory, :deck,
                :clank, :position, :rewards, :skill_points, :trash, :ignore_monster_path, :skip_crystal_cave,
                :replace_card_in_market, :discard_number, :spend_seven_for_two_secret_tomes,
                :take_secret_adjacent, :victory_points, :moved_to_crystal_cave
  attr_reader :health, :index

  STARTING_CLANK_CUBES = { 0 => 3, 1 => 2, 2 => 1, 3 => 0 }.freeze
  MAX_HEALTH = 10
  MAX_CLANK = 30
  START_COINS = 7

  def self.from_json(json)
    Model::Player.new(
      json['index'],
      position: Model::Position.from_json(json['position']),
      deck: Model::Deck.from_json(json['deck']),
      **json.symbolize_keys.reject { |k, _v| %i[index position deck].include?(k) }
    )
  end

  def initialize( # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    index = 0,
    health: nil,
    clank: nil,
    inventory: [],
    position: nil,
    deck: nil,
    attack_points: 0,
    move_points: 0,
    teleport: 0,
    coins: nil,
    skill_points: 0,
    rewards: [],
    trash: [], # TODO: array of types?
    ignore_monster_path: false,
    skip_crystal_cave: false,
    replace_card_in_market: false,
    discard_number: 0,
    spend_seven_for_two_secret_tomes: false,
    take_secret_adjacent: false,
    moved_to_crystal_cave: false,
    victory_points: 0
  )
    @index = index || 0
    @inventory = inventory || []
    @position = position || Model::Position.new
    @deck = deck || Model::Deck.new(Base::STARTING_DECK_CARDS)
    @clank = clank || STARTING_CLANK_CUBES[index]
    @inventory = inventory || []
    @attack_points = attack_points || 0
    @health = health || MAX_HEALTH
    @move_points = move_points || 0
    @teleport = teleport || 0
    @coins = coins || START_COINS
    @rewards = rewards || []
    @skill_points = skill_points || 0
    @trash = trash || []
    @ignore_monster_path = ignore_monster_path || false
    @skip_crystal_cave = skip_crystal_cave || false
    @replace_card_in_market = replace_card_in_market || false
    @discard_number = discard_number || 0
    @spend_seven_for_two_secret_tomes = spend_seven_for_two_secret_tomes || false
    @take_secret_adjacent = take_secret_adjacent || false
    @moved_to_crystal_cave = moved_to_crystal_cave || false
    @victory_points = victory_points
  end

  def health=(value)
    return unless value > MAX_HEALTH

    self.health = MAX_HEALTH
  end

  def inactive_clank
    clank - MAX_CLANK
  end

  def depths?
    position.depths?
  end

  def dead?
    health.negative?
  end

  def reset! # rubocop:disable Metrics/MethodLength
    @attack_points = 0
    @move_points = 0
    @teleport = 0
    @skill_points = 0
    @rewards = []
    @trash = []
    @ignore_monster_path = false
    @skip_crystal_cave = false
    @replace_card_in_market = false
    @discard_number = 0
    @spend_seven_for_two_secret_tomes = false
    @take_secret_adjacent = false
    @moved_to_crystal_cave = false
  end
end
