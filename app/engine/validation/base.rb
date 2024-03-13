# frozen_string_literal: true

class Validation::Base
  attr_reader :gameplay_data, :type, :value

  def initialize(gameplay_data, type:, value:)
    @gameplay_data = gameplay_data
    @type = type
    @value = value
  end

  def valid?
    public_send("valid_#{type}?")
  end

  def current_player
    @current_player ||= gameplay_data.current_player
  end

  def errors
    raise NotImplemented
  end
end
