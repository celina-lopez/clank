# frozen_string_literal: true

class Validation::Player < Validation::Base
  def attack?
    add_error_if_error('Not enough attack points', current_player.attack_points >= value)
  end

  def buy?
    result = add_error_if_error('Not in marketplace', current_player.position.marketplace?)
    result && add_error_if_error("Need #{current_player.coins - value} coins", current_player.coins >= value)
  end

  def buy_card?
    result = add_error_if_error('Card not found', card)
    result &= validate_funds
    result && validate_health
  end

  def move? # rubocop:disable Metrics/AbcSize
    next_to = current_player.position.next_to?(value)
    add_error_if_error('Cant go to tile', next_to)
    # TODO: certain cards negate this effect below
    add_error_if_error('Cant move if you been in a crystal cave', current_player.moved_to_crystal_cave)
    edge_metadata = current_player.position.edge_metadata(value)
    move_points = edge_metadata.fetch('move', 1)
    add_error_if_error('Not enough move points', current_player.move_points >= move_points)
    locked = edge_metadata.fetch('locked', false)
    add_error_if_error("Player doesn't have lock", current_player.inventory.find { |x| x['name'] == 'key' }) if locked
    danger = edge_metadata.fetch('danger', 0)
    add_error_if_error("Player doesn't have enough health", (current_player.health - danger).positive?)
  end

  def teleport?
    next_to = add_error_if_error('Not next to tile', current_player.position.next_to?(value))
    next_to && add_error_if_error('No teleport availabile', current_player.teleport.positive?)
  end

  private

  def card
    @card ||= CARDS.find { |x| x['name'] == value }
  end

  def validate_funds
    return true unless card['cost'].present?

    result = current_player.skill_points >= card['cost'].to_i
    add_error_if_error("Need #{card['cost'] - current_player.skill_points} more skill points", result)
  end

  def validate_health
    return true unless card['health'].present?

    result = current_player.attack_points >= card['health'].to_i
    add_error_if_error("Need #{card['health'] - current_player.attack_points} more attack points", result)
  end

  def validate_buy_conditions # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
    return true unless card['conditions'].present?

    card['conditions'].all? do |condition|
      if condition['type'] == 'can_buy'
        if condition['has'].present?
          current_player.inventory.any? { |x| x['name'] == condition['has'] } # TODO: double check item theme all
        elsif condition['has_companion'].present?
          current_player.deck.active.any? { |x| Base::COMPANION_NAMES.include?(x['name']) }
        elsif condition['two_of'].present?
          current_player.inventory.select { |x| x['name'] == condition['two_of'] }.count >= 2
        elsif condition['is_in'].present?
          current_player.position.public_send("#{condition['is_in']}?")
        else
          raise StandardError, 'UHHHHH what?'
        end
      else
        true
      end
    end
  end
end
