# frozen_string_literal: true

class Clank::Engine < Engine
  def self.klass_type(type)
    if Clank::Action::Player.actions_include?(type)
      'Player'
    elsif Clank::Base::CARD_NAMES.include?(type) || Clank::Action::Card.actions_include?(type)
      'Card'
    elsif Clank::Action::Game.actions_include?(type)
      'Game'
    end
  end
end
