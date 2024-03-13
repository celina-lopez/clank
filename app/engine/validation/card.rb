# frozen_string_literal: true

# TODO: this file needs some work
class Validation::Card < Validation::Base
  LOGIC_OPERATORS = ['==', '!=', '>', '>=', '<', '<='].freeze
  LOGIC_VALUES = ['true', 'false', /\d+/].freeze
  CONDITIONALS = %i[environment].freeze
  def valid?
    return true unless conditions.any?

    conditions.all? do |condition|
      evaluate_position(condition['logic'])
    end
  end

  def card
    @card ||= CARDS.find_by { |card| card['name'] == type }
  end

  def conditions
    @conditions ||= card.fetch('conditionals', []).filter { |cond| CONDITIONALS.include?(cond['type']) }
  end

  def evaluate_position(logic)
    logic_key, logic_operator, logic_value = logic.split
    logic_value = logic_value.match?(/\d+/) ? logic_value.to_i : logic_value.downcase
    current_player.send(logic_key).public_send(logic_operator, logic_value)
  end
end
