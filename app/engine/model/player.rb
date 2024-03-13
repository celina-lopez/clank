# frozen_string_literal: true

class Model::Player
  attr_accessor :name, :attack_points, :move_points, :teleport, :coins, :inventory, :deck,
                :active_clank, :position
  attr_reader :health

  STARTING_CLANK_CUBES = { 0 => 3, 1 => 2, 2 => 1, 3 => 0 }.freeze
  MAX_HEALTH = 10
  MAX_CLANK = 30

  def initialize(index = 0)
    @attack_points = 0
    @health = 10
    @move_points = 0
    @teleport = 0
    @coins = 0
    @inventory = []
    @position = Model::Position.new
    @deck = Model::Deck.new(Constants::STARTING_DECK_CARDS)
    @active_clank = starter_clank
    super
  end

  def skill_points
    deck.active_cards.map { |card| card['skill_points'] }.sum
  end

  def health=(value)
    return unless value > MAX_HEALTH

    self.health = MAX_HEALTH
  end

  def inactive_clank
    active_clank - MAX_CLANK
  end

  def depths?
    position.depths?
  end
end
