# frozen_string_literal: true

class LoveLetter::Validation::Player < Validation::Player
  def redeem_reward?
    add_error_if_error('Invalid format', current_player.rewards.dig(*value.split(',').map(&:to_i)).present?)
  end
end
