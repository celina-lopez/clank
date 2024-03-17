# frozen_string_literal: true

class Model::Player
  attr_accessor :attack_points, :move_points, :teleport, :coins, :inventory, :deck,
                :clank, :position, :rewards
  attr_reader :health, :index

  STARTING_CLANK_CUBES = { 0 => 3, 1 => 2, 2 => 1, 3 => 0 }.freeze
  MAX_HEALTH = 10
  MAX_CLANK = 30

  def self.from_json(json)
    # TODO: fix this later
    player = Model::Player.new
    player.attack_points = json['attack_points']
    player.move_points = json['move_points']
    player.teleport = json['teleport']
    player.coins = json['coins']
    player.inventory = json['inventory']
    player.deck = Model::Deck.from_json(json['deck'])
    player.clank = json['clank']
    player.position = Model::Position.from_json(json['position'])
    player.rewards = json['rewards']
    player.health = json['health']
    player
  end

  def initialize(index = 0)
    @index = index
    @inventory = []
    @position = Model::Position.new
    @deck = Model::Deck.new(Base::STARTING_DECK_CARDS)
    @clank = STARTING_CLANK_CUBES[index]
    initialize_player_attributes
    super()
  end

  def initialize_player_attributes
    @attack_points = 0
    @health = 10
    @move_points = 0
    @teleport = 0
    @coins = 0
    @rewards = []
  end

  def skill_points
    deck.active_cards.map { |card| card['skill_points'] }.sum
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
