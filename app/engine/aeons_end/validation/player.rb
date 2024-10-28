# frozen_string_literal: true

class AeonsEnd::Validation::Player < Validation::Player
  def redeem_reward?
    add_error_if_error('Invalid format', current_player.rewards.dig(*value.split(',').map(&:to_i)).present?)
  end

  def buy_card?
    result = add_error_if_error('Card not found', card)
    result && validate_funds
  end

  private

  def validate_funds
    return true unless card['cost'].present?

    cost = card['cost'].to_i
    result = current_player.skill_points >= cost
    add_error_if_error("Need #{card['cost'] - current_player.skill_points} more skill points", result)
  end
end
