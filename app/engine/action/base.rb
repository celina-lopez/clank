# frozen_string_literal: true

class Action::Base < Base
  attr_accessor :type, :value, :history

  def initialize(gameplay_data, type:, value:)
    @type = type
    @value = value
    @history = []
    super(gameplay_data)
  end

  def self.actions_include?(type)
    instance_methods(false).include?(type.to_sym) ||
      name.split('::')[1, 3]
          .join('::')
          .constantize
          .instance_methods(false)
          .include?(type.to_sym)
  end

  def execute!
    send(type)
    gameplay_data
  end
end
