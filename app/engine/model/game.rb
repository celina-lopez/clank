# frozen_string_literal: true

class Model::Game < Model::Base
  attr_accessor :id, :players, :current_player, :active_deck, :deck, :discard_deck, :marketplace_deck, :map,
                :dragon_clank

  STARTING_CLANK_CUBES = { 0 => 3, 1 => 2, 2 => 1, 3 => 0 }.freeze
  def initialize(num_players:)
    @id = SecureRandom.uuid
    @dragon_clank = 0
    initialize_players
    initialize_deck
    @map = Model::Map.new
    super
  end

  def initialize_deck
    deck = Validation::COMPANION_CARDS + Validation::DEVICE_CARDS + Validation::GEM_CARDS + Validation::ITEM_CARDS + Validation::MONSTER_CARDS
    deck.shuffle!
    @active_deck = deck.pop(6)
    @deck = deck
    @marketplace_deck = Validation::RESERVE_CARDS
    @discard_deck = []
  end

  def initialize_players
    @players = num_players.times.map do |i|
      Model::Player.new("Player #{i + 1}", starter_clank: STARTING_CLANK_CUBES[i])
    end
    @current_player = @players.first
  end
end
