# frozen_string_literal: true

class Validation::Card < Validation::Base
  def valid?
    result = add_error_if_error('Card not found', card.present?)
    return result unless conditions.any?

    conditions.all? do |condition|
      evaluate_position(condition['logic'])
    end
  end

  private

  def card
    @card ||= current_player.deck.active.find { |card| card['name'] == type }
  end

  def conditions
    @conditions ||= card.fetch('conditions', [])
  end
end
