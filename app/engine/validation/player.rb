# frozen_string_literal: true

class Validation::Player < Validation::Base
  def valid_attack?
    current_player.attack_points >= value
  end

  def valid_buy?
    # TODO: make this better for certain artificats
    current_player.coins >= value && current_player.position.marketplace?
  end

  def valid_move?
    # make position class with distance_to method
    current_player.position.distance_to(value) <= current_player.move_points
  end

  def valid_teleport?
    current_player.position.next_to?(value) && current_player.teleport.positive?
  end
end
