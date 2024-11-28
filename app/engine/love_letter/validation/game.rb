# frozen_string_literal: true

class LoveLetter::Validation::Game < Validation::Game
  def end_turn?
    add_error_if_error('Your game has ended', !gameplay_data.end_game)
    result = current_player.deck.active.size == 2
    add_error_if_error('You must a card in your hand', result)
    # result &= current_player.rewards.empty?
    # add_error_if_error('You must collect all your rewards', current_player.rewards.empty?)
    result
  end
end
