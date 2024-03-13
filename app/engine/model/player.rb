# frozen_string_literal: true

class Model::Player
  attr_accessor :name, :attack_points, :move_points, :teleport, :coins, :inventory, :active_deck, :deck,
                :discard_deck, :skill_points, :active_clank, :inactive_clank, :position
  attr_reader :health

  STARTING_CLANK_CUBES = { 0 => 3, 1 => 2, 2 => 1, 3 => 0 }.freeze
  MAX_HEALTH = 10

  def initialize(index = 0)
    @attack_points = 0
    @health = 10
    @move_points = 0
    @teleport = 0
    @coins = 0
    @inventory = []
    @position = Model::Position.new
    initialize_clank(STARTING_CLANK_CUBES[index])
    initialize_deck
    super
  end

  def initialize_deck
    starter_deck = Constants::STARTING_DECK_CARDS
    @active_deck = starter_deck.pop(5)
    @deck = starter_deck
    @discard_deck = []
    @skill_points = @active_deck.map { |card| card['skill_points'] }.sum
  end

  def initialize_clank(starter_clank)
    @active_clank = starter_clank
    @inactive_clank = 30 - starter_clank
  end

  def health=(value)
    return unless value > MAX_HEALTH

    self.health = MAX_HEALTH
  end
end
