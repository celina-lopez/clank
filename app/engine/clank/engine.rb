# frozen_string_literal: true

class Engine < Base
  def self.klass_type(type)
    if Action::Player.actions_include?(type)
      'Player'
    elsif Base::CARD_NAMES.include?(type) || Action::Card.actions_include?(type)
      'Card'
    elsif Action::Game.actions_include?(type)
      'Game'
    end
  end
end
