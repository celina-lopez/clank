# frozen_string_literal: true

class Validation::Card < Validation::Base
  LOGIC_OPERATORS = ['==', '!=', '>', '>=', '<', '<='].freeze
  LOGIC_VALUES = ['true', 'false', /\d+/].freeze
  CONDITIONALS = %i[environment].freeze

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
    @conditions ||= card.fetch('conditionals', []).filter { |cond| CONDITIONALS.include?(cond['type']) }
  end

  def evaluate_position(logic)
    logic_key, logic_operator, logic_value = logic.split
    logic_value = logic_value.match?(/\d+/) ? logic_value.to_i : logic_value.downcase
    result = current_player.send(logic_key).public_send(logic_operator, logic_value)
    add_error_if_error("Invalid conditional: #{logic}", result)
  end
end
