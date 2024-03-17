# frozen_string_literal: true

class Validation::Base < Base
  class InvalidMoveError < StandardError; end
  attr_reader :type, :value, :errors

  def initialize(gameplay_data, type:, value:, player_index: nil)
    @type = type
    @value = value
    @errors = []
    super(gameplay_data)
  end

  def valid_player_index?
    return true if player_index == current_player.index

    errors << 'You are not the current player'
    false
  end

  def valid?
    return true if valid_player_index? && public_send("#{type}?")

    raise InvalidMoveError, type
  end

  def error_messages
    errors.join(', ')
  end
end
