# frozen_string_literal: true

class Validation::Base
  class InvalidMoveError < StandardError; end
  attr_reader :gameplay_data, :type, :value

  def initialize(gameplay_data, type:, value:)
    @gameplay_data = gameplay_data
    @type = type
    @value = value
  end

  def valid?
    return true if public_send("valid_#{type}?")

    raise InvalidMoveError, type
  end

  def current_player
    @current_player ||= gameplay_data.current_player
  end

  def errors
    raise NotImplemented
  end
end
