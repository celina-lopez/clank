# frozen_string_literal: true

class Engine
  attr_accessor :gameplay_data, :validation_klass, :action_klass

  def initialize(gameplay_data)
    @gameplay_data = gameplay_data
    @validation_klass = Validation.new(self)
    @action_klass = Action.new(self)
  end

  def execute(type:, value:)
    raise 'Invalid request' unless validation_klass.valid?(type:, value:)

    action_klass.execute(type:, value:) # returns new gameplay data
  end
end
