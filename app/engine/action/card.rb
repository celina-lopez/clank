# frozen_string_literal: true

class Action::Card < Action::Base
  %i[health attack_points move_points coins clank teleport].each do |type|
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
