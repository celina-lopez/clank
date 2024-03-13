# frozen_string_literal: true

class Engine
  attr_accessor :gameplay_data, :validation_klass, :action_klass

  def initialize(gameplay_data)
    @gameplay_data = gameplay_data
    @validation_klass = Validation.new(self)
    @action_klass = Action.new(self)
  end

  def execute(type:, value:)
    klass_type = klass_type(type)
    valid = Validation.const_get(klass_type).new(gameplay_data, type:, value:).valid?
    raise 'Invalid request' unless valid

    Action.const_get(klass_type).new(gameplay_data, type:, value:).execute!
  end

  def klass_type(type)
    case type
    when Action::Player.actions_include?(type)
      'Player'
    when Constants::CARD_NAMES.include?(type)
      'Card'
    when Action::Game.actions_include?(type)
      'Game'
    end
  end
end
