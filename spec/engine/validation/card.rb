# frozen_string_literal: true

class Validation::Card < Validation::Base
  def valid?
    add_error_if_error('Card not found', card.present?)
  end

  private

  def card
    @card ||= current_player.deck.active.find { |card| card['name'] == type }
  end
end
