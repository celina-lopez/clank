# frozen_string_literal: true

class Clank::Model::Game < Model::Game
  attr_accessor :deck, :marketplace, :map, :dragon, :marketplace_items

  def self.from_json(json)
    Clank::Model::Game.new(
      monster: AeonsEnd::Model::Monster.from_json(json['monster']),
      marketplace: json['marketplace'],
      players: json['players'].map { |p| Clank::Model::Player.from_json(p) },
      current_player_index: json['current_player_index'],
      end_game: json['end_game']
    )
  end

  def initialize(
    new_players: nil,
    monster: nil,
    marketplace: AeonsEnd::Base::MARKETPLACE,
    players: nil,
    current_player_index: 0,
    end_game: false
  )
    @monster = monster || AeonsEnd::Model::Monster.new(AeonsEnd::Base::MONSTER_CARDS)
    @current_player_index = current_player_index
    @marketplace = marketplace
    @players = if new_players.present?
                 initialize_players(new_players)
               else
                 players
               end
    @eng_game = end_game
  end

  def next_player!
    current_player.reset!
    current_player.deck.reload_active_deck
    super
  end
end
