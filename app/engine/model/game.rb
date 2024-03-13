# frozen_string_literal: true

class Model::Game
  attr_accessor :id, :players, :current_player, :deck, :marketplace_deck, :map,
                :dragon_clank

  def initialize(num_players:)
    @id = SecureRandom.uuid
    @dragon_clank = 0
    @deck = Model::Deck.new(
      Constants::MISC_DECK + Constants::MONSTER_CARDS,
      num_of_active_cards: 6
    )
    @marketplace_deck = Constants::RESERVE_CARDS
    @map = Model::Map.new
    initialize_players
    super
  end

  def initialize_players
    @players = num_players.times.map do |i|
      Model::Player.new(i)
    end
    @current_player = @players.first
  end
end
