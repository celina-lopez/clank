# frozen_string_literal: true

class Action::Card < Action::Base
  MAX_HEALTH = 10
  def add_health
    current_player.health += value
    return unless current_player.health > MAX_HEALTH

    current_player.health = MAX_HEALTH
  end

  %i[attack_points move_points coins clank teleport].each do |type|
    define_method("add_#{type}") do
      current_player.public_send("#{type}=", current_player.public_send(type) + value)
    end
  end

  %i[clank].each do |type|
    define_method("remove_#{type}") do
      current_player.public_send("#{type}=", current_player.public_send(type) - value)
    end
  end
end
