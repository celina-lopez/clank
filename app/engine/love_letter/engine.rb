# frozen_string_literal: true

class LoveLetter::Engine < Engine
  def self.klass_type(type)
    if LoveLetter::Action::Player.actions_include?(type)
      'Player'
    elsif LoveLetter::Base::CARD_NAMES.include?(type) || LoveLetter::Action::Card.actions_include?(type)
      'Card'
    elsif LoveLetter::Action::Game.actions_include?(type)
      'Game'
    end
  end
end
