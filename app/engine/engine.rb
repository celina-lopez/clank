# frozen_string_literal: true

class Engine < Base
  def execute(type:, value:)
    klass = klass_type(type)
    valid = Validation.const_get(klass).new(gameplay_data, type:, value:).valid?
    raise 'Invalid request' unless valid

    self.gameplay_data = Action.const_get(klass).new(gameplay_data, type:, value:).execute!
  end

  def klass_type(type)
    self.class.klass_type(type)
  end

  def self.klass_type(type)
    if Action::Player.actions_include?(type)
      'Player'
    elsif Base::CARD_NAMES.include?(type)
      'Card'
    elsif Action::Game.actions_include?(type)
      'Game'
    end
  end
end
