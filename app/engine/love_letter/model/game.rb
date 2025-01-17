# frozen_string_literal: true

class LoveLetter::Model::Game < Model::Game
  attr_accessor :deck

  MAX_FAVOR_TOKENS = 13

  def self.from_json(json)
    LoveLetter::Model::Game.new(
      deck: Model::Deck.from_json(json['deck']),
      players: json['players'].map { |p| LoveLetter::Model::Player.from_json(p) },
      **json.symbolize_keys.reject { |k, _v| %i[deck players gameplay_data].include?(k) }
    )
  end

  def initialize(
    deck: Model::Deck.new(LoveLetter::Base::CARDS, num_of_active_cards: 0),
    **kwargs
  )
    @deck = deck
    super
  end

  def setup_deck(player_count)
    cards_aside = player_count == 2 ? deck.deck.pop(3) : deck.deck.pop(1)
    deck.active = cards_aside
  end

  def initialize_players(new_players)
    setup_deck(new_players.size)
    @players = new_players.each_with_index.map do |name, index|
      game_engine::Model::Player.new(
        index,
        name:,
        deck: Model::Deck.new(active: deck.deck.pop(index.zero? ? 2 : 1))
      )
    end
  end

  def next_player!
    current_player.reset!
    super
  end
end
