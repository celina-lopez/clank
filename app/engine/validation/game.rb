# frozen_string_literal: true

class Validation::Game < Validation::Base
  def end_turn?
    current_player.deck.active.empty? && current_player.rewards.empty?
  end

  def start_game?
    true
  end
end
