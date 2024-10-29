# frozen_string_literal: true

class AeonsEnd::Engine < Engine
  def self.klass_type(type)
    if Clank::Action::Player.actions_include?(type)
      'Player'
    elsif Clank::Action::Card.actions_include?(type)
      'Card'
    elsif Clank::Action::Game.actions_include?(type)
      'Game'
    end
  end
end
