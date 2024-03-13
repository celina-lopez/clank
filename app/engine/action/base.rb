# frozen_string_literal: true

class Action::Base
  attr_accessor :gameplay_data

  def initialize(gameplay_data, type:, value:)
    @gameplay_data = gameplay_data
    @type = type
    @value = value
  end

  def execute!
    send(type, value)
    gameplay_data
  end

  def current_player
    @current_player ||= gameplay_data.current_player
  end
end
