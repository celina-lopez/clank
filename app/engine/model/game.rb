# frozen_string_literal: true

class Model::Game
  attr_accessor :players, :current_player_index, :deck, :marketplace, :map,
                :dragon_clank

  def self.from_json(json)
    Model::Game.new(
      dragon_clank: json['dragon_clank'],
      deck: Model::Deck.from_json(json['deck']),
      marketplace: json['marketplace'],
      map: Model::Map.from_json(json['map']),
      players: json['players'].map { |p| Model::Player.from_json(p) },
      current_player_index: json['current_player_index']
    )
  end

  def initialize(num_players: nil, dragon_clank: 0, deck: Model::Deck.new( # rubocop:disable Metrics/MethodLength, Metrics/ParameterLists
    Base::MISC_DECK + Base::MONSTER_CARDS,
    num_of_active_cards: 6
  ), marketplace: Base::MARKETPLACE, map: Model::Map.new, players: nil,
                 current_player_index: 0)
    @dragon_clank = dragon_clank
    @current_player_index = current_player_index
    @map = map
    @deck = deck
    @marketplace = marketplace
    @players = if num_players.present?
                 num_players.times.map do |i|
                   Model::Player.new(i)
                 end
               else
                 players
               end
  end

  def initialize_players(num_players)
    @players = num_players.times.map do |i|
      Model::Player.new(i)
    end
  end

  def next_player!
    current_player.deck.reload_active_deck
    self.current_player_index = (current_player_index + 1) % players.length
  end

  def current_player
    players[current_player_index]
  end
end
