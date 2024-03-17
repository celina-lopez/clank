# frozen_string_literal: true

class Model::Game
  attr_accessor :players, :current_player, :deck, :marketplace_deck, :map,
                :dragon_clank

  def self.from_json(json)
    # TODO: fix this
    game = Model::Game.new(num_players: 0)
    game.dragon_clank = json['dragon_clank']
    game.deck = Model::Deck.from_json(json['deck'])
    game.marketplace_deck = json['marketplace_deck']
    game.map = Model::Map.from_json(json['map'])
    game.players = json['players'].map { |p| Model::Player.from_json(p) }
    game.current_player = Model::Player.from_json(json['current_player'])
    game
  end

  def initialize(num_players:)
    @dragon_clank = 0
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
