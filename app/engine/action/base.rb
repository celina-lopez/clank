# frozen_string_literal: true

class Action::Base
  attr_accesor :gameplay_data

  def initialize(gameplay_data, type:, value:)
    @gameplay_data = gameplay_data
    @type = type
    @value = value
  end

  def execute!
    send(type, value)
  end

  def current_player
    @current_player ||= gameplay_data.current_player
  end
end
