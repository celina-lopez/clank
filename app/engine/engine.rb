# frozen_string_literal: true

class Engine < Base
  attr_accessor :history

  def self.from_json(json, history: [])
    data = Model::Game.from_json(json)
    new(data, history:)
  end

  def initialize(gameplay_data = nil, history: [])
    @history = history
    # TODO: when certain inventory, increase dragon position
    # TODO: on trash select, update status trash options
    # TODO: market place active in game_helpers
    # TODO: dont lose health if move with danger path
    # TODO: backpack description on pop up and other inventory items
    # TODO: goblin text should say attack on card
    # TODO: i think i actually have to add the artificats
    # TODO: apothecary card, when click choose options
    # TODO: discard a card! to gain a health, we need to chose that jesus, apothecary
    # TODO: sometimes the use card doesn't work
    # TODO: coins not updating for some  reason
    # TODO: can't move to negative tiles, once on 0 tile with an artifact, then turn is auto done
    super(gameplay_data)
  end

  def execute(type:, value: nil, player_index: nil)
    klass = klass_type(type)
    validation_klass = Validation.const_get(klass).new(gameplay_data, type:, value:, player_index:)
    raise Validation::Base::InvalidMoveError, validation_klass.error_messages unless validation_klass.valid?

    history << { type:, value:, player_index: }
    action_klass = Action.const_get(klass).new(gameplay_data, type:, value:)
    self.gameplay_data = action_klass.execute!
    history.concat(action_klass.history)
    gameplay_data
  end

  def klass_type(type)
    self.class.klass_type(type)
  end

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
