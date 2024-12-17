# frozen_string_literal: true

class Labeler
  attr_reader :players

  def initialize(players:)
    @players = players
  end

  def label(history)
    raise NotImplementedError, 'Labeler not implemented'
  end

  def fetch_player(index)
    players.fetch(index.to_i, {})['name']
  end

  def by_player(history)
    fetch_player(history['player_index'])
  end
end
