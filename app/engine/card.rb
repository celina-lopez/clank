# frozen_string_literal: true

class Card # rubocop:disable Style/Documentation
  attr_accessor :name,
                :cost,
                :actions,
                :attack,
                :conditionals,
                :immediate_actions,
                :on_acquire

  def initialize( # rubocop:disable Metrics/ParameterLists
    name:,
    cost: 0,
    actions: [],
    attack: 0,
    conditionals: [],
    immediate_actions: [],
    on_acquire: [],
    **_args
  )
    @name = name
    @cost = cost
    @actions = actions
    @attack = attack
    @conditionals = conditionals
    @immediate_actions = immediate_actions
    @on_acquire = on_acquire
  end

  def valid?
    if conditionals.any?
      conditionals.all?(&:valid?)
    else
      true
    end
  end

  def self.from_yaml(data)
    new(**data.deep_symbolize_keys)
  end
end
