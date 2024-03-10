# frozen_string_literal: true

class Card # rubocop:disable Style/Documentation
  attr_accessor :type,
                :cost,
                :actions,
                :attack,
                :conditionals,
                :immediate_actions

  def initialize( # rubocop:disable Metrics/ParameterLists
    type:,
    cost: 0,
    actions: [],
    attack: 0,
    conditionals: [],
    immediate_actions: []
  )
    @type = type
    @cost = cost
    @actions = actions
    @attack = attack
    @conditionals = conditionals
    @immediate_actions = immediate_actions
  end

  def valid?
    if conditionals.any?
      conditionals.all?(&:valid?)
    else
      true
    end
  end
end

class StarterCard < Card
  def initialize(actions: [])
    super(type: :starter, actions:)
  end
end

class ReserveCard < Card
  def initialize(cost: 0, actions: [])
    super(
      type: :reserve_card,
      cost:,
      actions:,
    )
  end
end

class MonsterCard < Card
  def initialize(actions: [], attack: 0, conditionals: [], immediate_actions: [])
    super(
      type: :monster,
      actions:,
      attack:,
      conditionals:,
      immediate_actions:,
    )
  end
end

class GemCard < Card
  def initialize(cost:, conditionals: [])
    super(
      type: :gem,
      cost:,
      actions: [{ draw: 1 }],
      conditionals:,
      immediate_actions: [{ clank: 2 }]
    )
  end
end

class ItemCard < Card
  def initialize(cost: 0, actions: [], immediate_actions: [])
    super(
      type: :item,
      cost:,
      actions:,
      immediate_actions:,
    )
  end
end

class DeviceCard < Card
  def initialize(cost:, actions: [], conditionals: [], immediate_actions: [])
    super(
      type: :device,
      cost:,
      actions:,
      conditionals:,
      immediate_actions:
    )
  end
end

class CompanionCard < Card
  def initialize(cost: 0, actions: [], conditionals: [])
    super(
      type: :companions,
      cost:,
      actions: [],
      conditionals: [],
    )
  end
end
