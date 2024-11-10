# frozen_string_literal: true

class AeonsEnd::Engine < Engine
  def self.klass_type(type)
    if AeonsEnd::Action::Player.actions_include?(type)
      'Player'
    elsif AeonsEnd::Action::Card.actions_include?(type)
      'Card'
    elsif AeonsEnd::Action::Game.actions_include?(type)
      'Game'
    else
      # TODO: fix
      'Card'
    end
  end
end
