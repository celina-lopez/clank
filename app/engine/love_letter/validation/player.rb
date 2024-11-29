# frozen_string_literal: true

class LoveLetter::Validation::Player < Validation::Player
  [
    %w[trade_card king trade_card_points],
    %w[keep_card chancellor keep_card_points],
    %w[choose_player_to_discard prince choose_player_to_discard_points],
    %w[choose_player_to_compare baron choose_player_to_compare_points],
    %w[choose_player_to_reveal priest choose_player_to_reveal_card]
  ].each do |method, card_name, skill|
    define_method("#{method}?") do
      ok = add_error_if_error('Player has played the handmaid', !protected?(value))
      ok && add_error_if_error("You do not have #{card_name.humanize} card.", current_player.send(skill).positive?)
    end
  end

  def choose_player_to_guess?
    player_index = value.split(',').first
    ok = add_error_if_error('Player has played the handmaid', !protected?(player_index))
    ok && add_error_if_error('You must choose a player to guess', current_player.choose_player_to_guess_card.positive?)
  end

  private

  def protected?(index)
    chosen_player = gameplay_data.players.find { |player| player.index == index.to_i }
    chosen_player.deck.active.find { |card| card['name'] == 'handmaid' }.present?
  end
end
