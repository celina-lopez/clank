# frozen_string_literal: true

class Validation::Player < Validation::Base
  def attack?
    add_error_if_error('Not enough attack points', current_player.attack_points >= value)
  end

  def play_all_cards?
    add_error_if_error('No cards to play', current_player.deck.active.present?)
  end

  private

  def card
    @card ||= game_engine::Base::CARDS.find { |x| x['name'] == value }
  end
end
