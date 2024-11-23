# frozen_string_literal: true

class Clank::Model::Game < Model::Game
  attr_accessor :deck, :marketplace, :map, :dragon, :marketplace_items

  def self.from_json(json) # rubocop:disable Metrics/MethodLength
    Clank::Model::Game.new(
      dragon: Clank::Model::Dragon.from_json(json['dragon']),
      deck: Clank::Model::Deck.from_json(json['deck']),
      marketplace: json['marketplace'],
      marketplace_items: json['marketplace_items'],
      map: Clank::Model::Map.from_json(json['map']),
      players: json['players'].map { |p| Clank::Model::Player.from_json(p) },
      current_player_index: json['current_player_index'],
      end_game: json['end_game'],
      results: json['results']
    )
  end

  def initialize(
    new_players: nil,
    dragon: nil,
    deck: Clank::Model::Deck.new(Clank::Base::STARTING_GAME_CARDS, num_of_active_cards: 6),
    marketplace: Clank::Base::MARKETPLACE,
    map: Clank::Model::Map.new,
    players: nil,
    current_player_index: 0,
    marketplace_items: Clank::Base::MARKETPLACE_ITEMS,
    end_game: false,
    results: []
  )
    @dragon = dragon || Clank::Model::Dragon.new(num_players: new_players&.length)
    @current_player_index = current_player_index
    @map = map
    @deck = deck
    @marketplace = marketplace
    @marketplace_items = marketplace_items
    @players = if new_players.present?
                 initialize_players(new_players)
               else
                 players
               end
    @results = results
    @eng_game = end_game
  end

  def next_player!
    current_player.reset!
    current_player.deck.reload_active_deck
    activate_current_player_actions
    super
  end

  private

  def activate_current_player_actions
    active_actions = current_player.deck.active.flat_map do |x|
      x.fetch('actions', []).first&.keys
    end & %w[ignore_monster_path skip_crystal_cave]
    active_actions.each { |action| current_player.send("#{action}=", true) } if active_actions.any?
  end
end
