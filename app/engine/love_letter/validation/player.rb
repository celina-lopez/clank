# frozen_string_literal: true

class LoveLetter::Validation::Player < Validation::Player
  [
    %w[trade_card king],
    %w[keep_card chancellor],
    %w[choose_player_to_discard prince],
    %w[choose_player_to_compare baron],
    %w[choose_player_to_reveal priest]
  ].each do |method, card_name|
    define_method("#{method}?") do
      ok = add_error_if_error('Player has played the handmaid', protected?(value))
      ok &= add_error_if_error("You do not have #{card_name.humanize} card.", card?(card_name))
      ok
    end
  end

  def choose_player_to_guess?
    player_index = value.split(',').first
    ok = add_error_if_error('Player has played the handmaid', protected?(player_index))
    ok &= add_error_if_error('You must choose a player to guess', card?('guard'))
    ok
  end

  private

  def card?(name)
    current_player.deck.active.find { |card| card['name'] == name }
  end

  def protected?(index)
    chosen_player = gameplay_data.players.find { |player| player.index == index.to_i }
    chosen_player.deck.active.find { |card| card['name'] == 'handmaid' }.present?
  end
end
