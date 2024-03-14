# frozen_string_literal: true

class Action::Base < Base
  attr_accessor :type, :value

  def initialize(gameplay_data, type:, value:)
    @type = type
    @value = value
    super(gameplay_data)
  end

  def self.actions_include?(type)
    instance_methods(false).include?(type.to_sym)
  end

  def execute!
    send(type)
    gameplay_data
  end
end
