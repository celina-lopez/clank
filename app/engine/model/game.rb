# frozen_string_literal: true

class Model::Game
  attr_accessor :players, :current_player, :deck, :marketplace_deck, :map,
                :dragon_clank

  def self.from_json(json)
    Model::Game.new(
      dragon_clank: json['dragon_clank'],
      deck: Model::Deck.from_json(json['deck']),
      marketplace_deck: json['marketplace_deck'],
      map: Model::Map.from_json(json['map']),
      players: json['players'].map { |p| Model::Player.from_json(p) },
      current_player: Model::Player.from_json(json['current_player'])
    )
  end

  def initialize(num_players: nil, dragon_clank: 0, deck: nil, marketplace_deck: nil, map: nil, players: nil, # rubocop:disable Metrics/ParameterLists
                 current_player: nil)
    @dragon_clank = dragon_clank
    if num_players.present?
      initialize_new_game(num_players:)
    else
      @deck = deck
      @marketplace_deck = marketplace_deck
      @map = map
      @players = players
      @current_player = current_player
    end
  end

  def initialize_new_game(num_players:)
    @deck = Model::Deck.new(
      Base::MISC_DECK + Base::MONSTER_CARDS,
      num_of_active_cards: 6
    )
    @marketplace_deck = Base::RESERVE_CARDS
    @map = Model::Map.new
    initialize_players(num_players)
    super()
  end

  def initialize_players(num_players)
    @players = num_players.times.map do |i|
      Model::Player.new(i)
    end
    @current_player = @players.first
  end

  def next_player!
    current_player.deck.reload_active_deck
    self.current_player = players[(current_player.index + 1) % players.length]
  end
end
