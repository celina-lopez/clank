# frozen_string_literal: true

class Validation::Game < Validation::Base
  def end_turn?
    result = current_player.deck.active.empty?
    add_error_if_error('You must play all your cards in your hand', result)
    result &= current_player.rewards.empty?
    add_error_if_error('You must collect all your rewards', current_player.rewards.empty?)
    result
  end

  def start_game?
    true
  end
end
