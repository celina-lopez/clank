# frozen_string_literal: true

class Clank::Validation::Game < Validation::Game
  def end_turn?
    result = add_error_if_error('Your game has ended', !gameplay_data.end_game)
    result &= add_error_if_error('You must play all your cards in your hand', current_player.deck.active.empty?)
    result && add_error_if_error('You must collect all your rewards', current_player.rewards.empty?)
  end
end
