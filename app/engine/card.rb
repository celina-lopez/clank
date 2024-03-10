class Card
  attr_accessor :name,
                :victory_points,
                :cost,
                :actions,
                :attack,
                :conditionals,
                :immediate_actions

  def initialize(
    name:,
    victory_points: 0,
    cost: 0,
    actions: [],
    attack: 0,
    conditionals: [],
    immediate_actions: []
  )
    @name = name
    @victory_points = victory_points
    @cost = cost
    @actions = actions
    @attack = attack
    @conditionals = conditionals
    @immediate_actions = immediate_actions
  end
end
