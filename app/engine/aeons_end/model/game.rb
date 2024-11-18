# frozen_string_literal: true

class AeonsEnd::Model::Game < Model::Game
  attr_accessor :deck, :marketplace, :monster, :marketplace_items, :turn_order, :gravehold, :discard_and_draw_points,
                :health_and_draw_points

  def self.from_json(json)
    AeonsEnd::Model::Game.new(
      monster: AeonsEnd::Model::Monster.from_json(json['monster']),
      players: json['players'].map { |p| AeonsEnd::Model::Player.from_json(p) },
      **json.symbolize_keys.reject { |k, _v| %i[monster players].include?(k) }
    )
  end

  def initialize( # rubocop:disable Metrics/ParameterLists
    monster: nil,
    marketplace: AeonsEnd::Base::MARKETPLACE,
    turn_order: nil,
    gravehold: 31,
    discard_and_draw_points: [],
    health_and_draw_points: [],
    current_player_index: 0,
    **kwargs
  )
    super
    @monster = monster || AeonsEnd::Model::Monster.new
    @marketplace = marketplace
    @turn_order = turn_order || [0, nil, nil, nil, -1, -1] # TODO: always start with a player
    @current_player_index = current_player_index || 0
    @gravehold = gravehold || 31
    @discard_and_draw_points = discard_and_draw_points
    @health_and_draw_points = health_and_draw_points
  end

  def next_player!
    current_player.reset!
    current_player.deck.reload_active_deck # TODO: Make sure to refresh the deck without the ones on the breaches
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

    self.current_player_index = if turn.nil?
                                  # TODO: wild card? maybe keep it
                                  rand(players.size) # TODO: check if this is seeded
                                else
                                  turn
                                end
    return unless turn_order.empty?

    self.turn_order = generate_turn_order!
  end
end
