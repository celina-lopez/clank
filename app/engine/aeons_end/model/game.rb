# frozen_string_literal: true

class AeonsEnd::Model::Game < Model::Game
  attr_accessor :deck, :marketplace, :map, :dragon, :marketplace_items, :turn_order, :players

  def self.from_json(json)
    AeonsEnd::Model::Game.new(
      monster: AeonsEnd::Model::Monster.from_json(json['monster']),
      marketplace: json['marketplace'],
      players: json['players'].map { |p| AeonsEnd::Model::Player.from_json(p) },
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
    end_game: false,
    turn_order: nil,
    gravehold: 31
  )
    @monster = monster || AeonsEnd::Model::Monster.new
    @current_player_index = current_player_index
    @marketplace = marketplace
    @players = if new_players.present?
                 initialize_players(new_players)
               else
                 players
               end
    @eng_game = end_game
    @turn_order = turn_order || generate_turn_order!
    @gravehold = gravehold || 31
  end

  def next_player!
    current_player.reset!
    current_player.deck.reload_active_deck
    next_in_turn_order
  end

  def generate_turn_order!
    turns = Array.new(6)
    players.size.times do |i|
      turns[i] = i
    end
    # dragon is -1
    turns[-1] = -1
    turns[-2] = -1
    turns.shuffle
  end

  def next_in_turn_order
    turn = turn_order.pop
    self.current_player_index = if turn == -1
                                  # TODO: dragon actions
                                  0 # remove
                                elsif turn.nil?
                                  # TODO: wild card? maybe keep it
                                  rand(players.size) # TODO: check if this is seeded
                                else
                                  turn_order.pop
                                end
    return unless turn_order.empty?

    self.turn_order = generate_turn_order!
  end
end
