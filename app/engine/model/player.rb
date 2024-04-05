# frozen_string_literal: true

class Model::Player
  attr_accessor :attack_points, :move_points, :teleport, :coins, :inventory, :deck,
                :clank, :position, :rewards, :skill_points
  attr_reader :health, :index

  STARTING_CLANK_CUBES = { 0 => 3, 1 => 2, 2 => 1, 3 => 0 }.freeze
  MAX_HEALTH = 10
  MAX_CLANK = 30
  START_COINS = 7

  def self.from_json(json) # rubocop:disable Metrics/MethodLength
    Model::Player.new(
      json['index'],
      health: json['health'],
      clank: json['clank'],
      inventory: json['inventory'],
      position: Model::Position.from_json(json['position']),
      deck: Model::Deck.from_json(json['deck']),
      attack_points: json['attack_points'],
      move_points: json.fetch('move_points', 0),
      teleport: json['teleport'],
      coins: json['coins'],
      rewards: json['rewards'],
      skill_points: json['skill_points']
    )
  end

  def initialize( # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists
    index = 0,
    health: MAX_HEALTH,
    clank: STARTING_CLANK_CUBES[index],
    inventory: [],
    position: Model::Position.new,
    deck: Model::Deck.new(Base::STARTING_DECK_CARDS),
    attack_points: 0,
    move_points: 0,
    teleport: 0,
    coins: START_COINS,
    skill_points: 0,
    rewards: []
  )
    @index = index
    @inventory = inventory
    @position = position
    @deck = deck
    @clank = clank
    @inventory = inventory
    @attack_points = attack_points
    @health = health
    @move_points = move_points || 0
    @teleport = teleport
    @coins = coins
    @rewards = rewards
    @skill_points = skill_points
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
end
