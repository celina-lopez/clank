# frozen_string_literal: true

# TODO: this file needs some work
class Validation::Card < Validation::Base
  LOGIC_OPERATORS = ['==', '!=', '>', '>=', '<', '<='].freeze
  LOGIC_VALUES = ['true', 'false', /\d+/].freeze
  CONDITIONALS = %i[environment].freeze

  def valid?
    return false unless valid_card?
    return true unless conditions.any?

    conditions.all? do |condition|
      evaluate_position(condition['logic'])
    end
  end

  def valid_card?
    return true if card.present?

    errors << 'Card not found'
    false
  end

  def card
    @card ||= current_player.deck.active.find { |card| card['name'] == type }
  end

  def conditions
    @conditions ||= card.fetch('conditionals', []).filter { |cond| CONDITIONALS.include?(cond['type']) }
  end

  def evaluate_position(logic)
    logic_key, logic_operator, logic_value = logic.split
    logic_value = logic_value.match?(/\d+/) ? logic_value.to_i : logic_value.downcase
    valid = current_player.send(logic_key).public_send(logic_operator, logic_value)
    errors << "Invalid conditional: #{logic}" unless valid
    valid
  end
end
