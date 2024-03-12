# frozen_string_literal: true

# TODO: this file needs some work
class Validation::Card < Validation::Base
  LOGIC_OPERATORS = ['==', '!=', '>', '>=', '<', '<='].freeze
  LOGIC_VALUES = ['true', 'false', /\d+/].freeze
  VALID_CONDITIONALS = %i[environment].freeze
  def valid?
    return true unless any_conditions?

    valid_conditons.all? do |condition|
      evaluate_position(condition['logic'])
    end
  end

  def card
    @card ||= [COMPANION_CARDS, DEVICE_CARDS, GEM_CARDS, ITEM_CARDS,
               MONSTER_CARDS, RESERVE_CARDS, STARTING_DECK_CARDS].flatten.find_by do |card_type|
      return card_type.find { |card| card['name'] == type }
    end
  end

  def valid_conditons
    card.fetch('conditionals', []).filter { |cond| VALID_CONDITIONALS.include?(cond['type']) }
  end

  def any_conditions?
    valid_conditons.any?
  end

  def evaluate_position(logic)
    logic_key, logic_operator, logic_value = logic.split
    logic_value = logic_value.match?(/\d+/) ? logic_value.to_i : logic_value.downcase
    current_player.position.send(logic_key).public_send(logic_operator, logic_value)
  end
end
