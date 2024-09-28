# frozen_string_literal: true

class Engine < Base
  attr_accessor :history

  def self.from_json(json, history: [])
    data = game_engine::Model::Game.from_json(json)
    new(data, history:)
  end

  def initialize(gameplay_data = nil, history: [])
    @history = history
    super(gameplay_data)
  end

  def execute(type:, value: nil, player_index: nil) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    if player_index.present? && player_index != current_player_index
      raise Validation::Base::InvalidMoveError,
            'Not current player'
    end
    klass = klass_type(type)
    validation_klass = game_engine::Validation.const_get(klass).new(gameplay_data, type:, value:, player_index:)
    raise Validation::Base::InvalidMoveError, validation_klass.error_messages unless validation_klass.valid?

    history << { type:, value:, player_index: }
    action_klass = game_engine::Action.const_get(klass).new(gameplay_data, type:, value:)
    self.gameplay_data = action_klass.execute!
    history.concat(action_klass.history)
    gameplay_data
  end

  def self.game_engine
    name.deconstantize.constantize
  end

  def klass_type(type)
    self.class.klass_type(type)
  end

  def self.klass_type(type)
    raise NotImplementedError
  end
end
