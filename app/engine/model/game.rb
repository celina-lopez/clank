# frozen_string_literal: true

class Model::Game
  attr_accessor :players, :current_player_index, :deck, :marketplace, :map, :dragon,
                :marketplace_items, :end_game, :results

  def self.from_json(json)
    Model::Game.new(
      dragon: Model::Dragon.from_json(json['dragon']),
      deck: Model::Deck.from_json(json['deck']),
      marketplace: json['marketplace'],
      marketplace_items: json['marketplace_items'],
      map: Model::Map.from_json(json['map']),
      players: json['players'].map { |p| Model::Player.from_json(p) },
      current_player_index: json['current_player_index'],
      end_game: json['end_game'],
      results: json['results']
    )
  end

  def initialize(
    num_players: nil,
    dragon: Model::Dragon.new,
    deck: Model::Deck.new(Base::STARTING_GAME_CARDS, num_of_active_cards: 6),
    marketplace: Base::MARKETPLACE,
    map: Model::Map.new,
    players: nil,
    current_player_index: 0,
    marketplace_items: Base::MARKETPLACE_ITEMS,
    end_game: false,
    results: []
  )
    @dragon = dragon
    @current_player_index = current_player_index
    @map = map
    @deck = deck
    @marketplace = marketplace
    @marketplace_items = marketplace_items
    @players = if num_players.present?
                 initialize_players(num_players)
               else
                 players
               end
    @results = results
    @eng_game = end_game
  end

  def initialize_players(num_players)
    @players = num_players.times.map do |i|
      Model::Player.new(i)
    end
  end

  def next_player!
    current_player.reset!
    current_player.deck.reload_active_deck
    activate_current_player_actions
    self.current_player_index = (current_player_index + 1) % players.length
  end

  def current_player
    players[current_player_index]
  end

  private

  def activate_current_player_actions
    active_actions = current_player.deck.active.map do |x|
      x.fetch('actions', []).first&.keys
    end & %w[ignore_monster_path skip_crystal_cave spend_seven_for_two_secret_tomes]
    active_actions.each { |action| current_player.send("#{action}=", true) } if active_actions.any?
  end
end
