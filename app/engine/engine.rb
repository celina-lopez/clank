# frozen_string_literal: true

class Engine < Base
  def self.from_json(json)
    data = Model::Game.from_json(json)
    new(data)
  end

  def execute(data)
    type, value, player_index = data.values_at('type', 'value', 'player_index')
    klass = klass_type(type)
    validation_klass = Validation.const_get(klass).new(gameplay_data, type:, value:, player_index:)
    raise Validation::Base::InvalidMoveError, validation_klass.error_messages unless validation_klass.valid?

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
