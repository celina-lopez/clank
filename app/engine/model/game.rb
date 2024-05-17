# frozen_string_literal: true

class Model::Game
  attr_accessor :players, :current_player_index, :deck, :marketplace, :map, :dragon

  def self.from_json(json)
    Model::Game.new(
      dragon: Model::Dragon.from_json(json['dragon']),
      deck: Model::Deck.from_json(json['deck']),
      marketplace: json['marketplace'],
      map: Model::Map.from_json(json['map']),
      players: json['players'].map { |p| Model::Player.from_json(p) },
      current_player_index: json['current_player_index']
    )
  end

  def initialize(num_players: nil, dragon: Model::Dragon.new, deck: Model::Deck.new( # rubocop:disable Metrics/ParameterLists
    Base::STARTING_GAME_CARDS,
    num_of_active_cards: 6
  ), marketplace: Base::MARKETPLACE, map: Model::Map.new, players: nil,
                 current_player_index: 0)
    @dragon = dragon
    @current_player_index = current_player_index
    @map = map
    @deck = deck
    @marketplace = marketplace
    @players = if num_players.present?
                 initialize_players(num_players)
               else
                 players
               end
  end

  def initialize_players(num_players)
    @players = num_players.times.map do |i|
      Model::Player.new(i)
    end
  end

  def next_player! # rubocop:disable Metrics/AbcSize
    current_player.deck.reload_active_deck
    current_player.move_points = 0
    current_player.skill_points = 0
    current_player.attack_points = 0
    current_player.moved_to_crystal_cave = false
    current_player.take_secret_adjacent = false
    current_player.spend_seven_for_two_secret_tomes = false
    current_player.replace_card_in_market = false
    current_player.ignore_monster_path = false
    self.current_player_index = (current_player_index + 1) % players.length
  end

  def current_player
    players[current_player_index]
  end
end
