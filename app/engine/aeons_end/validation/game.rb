# frozen_string_literal: true

class AeonsEnd::Validation::Game < Validation::Game
  def end_turn?
    add_error_if_error('Your game has ended', !gameplay_data.end_game)
    result &= current_player.rewards.empty?
    add_error_if_error('You must collect all your rewards', current_player.rewards.empty?)
    result
  end
end
