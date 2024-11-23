# frozen_string_literal: true

class LoveLetter::Model::Game < Model::Game
  attr_accessor :deck

  MAX_FAVOR_TOKENS = 13

  def self.from_json(json)
    LoveLetter::Model::Game.new(
      deck: LoveLetter::Model::Deck.from_json(json['deck']),
      players: json['players'].map { |p| LoveLetter::Model::Player.from_json(p) },
      **json.symbolize_keys.reject { |k, _v| %i[deck players].include?(k) }
    )
  end

  def initialize(
    deck: LoveLetter::Model::Deck.new(LoveLetter::Base::CARDS, num_of_active_cards: 0),
    **kwargs
  )
    @deck = deck
    super
  end

  def setup_deck(player_count)
    cards_aside = player_count == 2 ? deck.active.pop(3) : deck.active.pop(1)
    deck.discarded.concat(cards_aside)
  end

  def initialize_players(new_players)
    count = -1
    setup_deck(new_players.size)
    @players = new_players.each_with_index.map do |name, index|
      count += 1
      game_engine::Model::Player.new(
        count,
        name:,
        deck: LoveLetter::Model::Deck.new(active: @deck.deck.pop(index.zero? ? 2 : 1))
      )
    end
  end

  def next_player!
    current_player.reset!
    super
  end
end
