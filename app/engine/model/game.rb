# frozen_string_literal: true

class Model::Game < Base
  attr_accessor :players, :current_player_index, :end_game, :results

  def initialize(**kwargs)
    super
    @current_player_index = kwargs[:current_player_index] || 0
    @players = if kwargs[:new_players].present?
                 initialize_players(kwargs[:new_players])
               else
                 kwargs[:players]
               end
    @results = kwargs[:results]
    @end_game = kwargs[:end_game]
  end

  def initialize_players(new_players)
    count = -1
    @players = new_players.map do |name|
      count += 1
      game_engine::Model::Player.new(count, name:)
    end
  end

  def next_player!
    self.current_player_index = (current_player_index + 1) % players.length
  end

  def current_player
    players[current_player_index]
  end
end
