# frozen_string_literal: true

class Validation::Player < Validation::Base
  def attack?
    result = current_player.attack_points >= value
    add_error_if_error('Not enough attack points', result)
  end

  def buy?
    result = add_error_if_error('Not in marketplace', current_player.position.marketplace?)
    result &= current_player.coins >= value
    add_error_if_error("Need #{current_player.coins - value} coins", current_player.coins >= value)
    result
  end

  def buy_card?
    result = add_error_if_error('Card not found', card)
    result &= validate_funds
    result &= validate_health
    result
  end

  def move?
    # TODO: still need to check locks
    # TODO: health
    distance_to = current_player.position.distance_to(value)
    result = distance_to <= current_player.move_points
    add_error_if_error("Need #{distance_to - current_player.move_points}", result)
  end

  def teleport?
    add_error_if_error('Not next to tile', current_player.position.next_to?(value))
    result = current_player.position.next_to?(value) && current_player.teleport.positive?
    add_error_if_error('No teleport availabile', result)
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
end
