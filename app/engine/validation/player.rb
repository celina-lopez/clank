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
    @card ||= CARDS.find { |x| x['name'] == value }
  end

  def gem_card_conditional?
    has_gem_collector = current_player.deck.active.find { |x| x['name'] == 'gem_collector' }
    return false unless has_gem_collector

    GEM_CARD_NAMES.include?(value)
  end
end
