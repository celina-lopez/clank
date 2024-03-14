# frozen_string_literal: true

class Validation::Base < Base
  class InvalidMoveError < StandardError; end
  attr_reader :type, :value

  def initialize(gameplay_data, type:, value:)
    @type = type
    @value = value
    super(gameplay_data)
  end

  def valid?
    return true if public_send("#{type}?")

    raise InvalidMoveError, type
  end

  def errors
    raise NotImplemented
  end
end
