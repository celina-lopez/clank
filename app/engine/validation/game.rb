# frozen_string_literal: true

class Validation::Game < Validation::Base
  def valid_end_turn?
    current_player.hand.empty?
  end

  def valid_start_game?
    true
  end
end
