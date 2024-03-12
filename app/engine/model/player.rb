# frozen_string_literal: true

class Model::Player
  attr_accessor :name, :attack_points, :health, :move_points, :teleport, :coins, :inventory, :active_deck, :deck,
                :discard_deck, :skill_points, :active_clank, :inactive_clank, :position

  def initialize(name, starter_clank: 0)
    @name = name
    @attack_points = 0
    @health = 10
    @move_points = 0
    @teleport = 0
    @coins = 0
    @inventory = []
    @position = Model::Position.new
    initialize_clank(starter_clank)
    initialize_deck
    super()
  end

  def initialize_deck
    starter_deck = YAML.load_file('config/game/starting_deck.yml')
    @active_deck = starter_deck.pop(5)
    @deck = starter_deck
    @discard_deck = []
    @skill_points = @active_deck.map { |card| card['skill_points'] }.sum
  end

  def initialize_clank(starter_clank)
    @active_clank = starter_clank
    @inactive_clank = 30 - starter_clank
  end
end
