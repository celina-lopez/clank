# frozen_string_literal: true

class Model::Game
  attr_accessor :id, :players, :current_player, :active_deck, :deck, :discard_deck, :marketplace_deck, :map,
                :dragon_clank

  def initialize(num_players:)
    @id = SecureRandom.uuid
    @dragon_clank = 0
    initialize_players
    initialize_deck
    @map = Model::Map.new
    super
  end

  def initialize_deck
    self.deck = Constants::MISC_DECK + Constants::MONSTER_CARDS
    deck.shuffle!
    @active_deck = deck.pop(6)
    @deck = deck
    @marketplace_deck = Constants::RESERVE_CARDS
    @discard_deck = []
  end

  def initialize_players
    @players = num_players.times.map do |i|
      Model::Player.new(i)
    end
    @current_player = @players.first
  end
end
