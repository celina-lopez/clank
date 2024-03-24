# frozen_string_literal: true

class Validation::Base < Base
  class InvalidMoveError < StandardError; end
  attr_reader :type, :value, :errors, :player_index

  def initialize(gameplay_data, type:, value:, player_index: nil)
    @type = type
    @value = value
    @player_index = player_index
    @errors = []
    super(gameplay_data)
  end

  def valid_player_index?
    return true if player_index == current_player_index

    errors << 'You are not the current player'
    false
  end

  def valid?
    return true if valid_player_index? && public_send("#{type}?")

    raise InvalidMoveError, (error_messages || type)
  end

  def error_messages
    errors.join(', ') if errors.any?
  end

  def add_error_if_error(message, result = false) # rubocop:disable Style/OptionalBooleanParameter
    errors << message unless result
    result
  end
end
