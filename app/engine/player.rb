class Player # rubocop:disable Style/Documentation
  attr_accessor :deck,
                :hand,
                :discard,
                :clank_cubes,
                :attack_points,
                :coins,
                :health,
                :position

  def initialize( # rubocop:disable Metrics/ParameterLists
    deck: [],
    hand: [],
    discard: [],
    clank_cubes: 0,
    attack_points: 0,
    coins: 7,
    health: 10,
    position: [0, 0],
  )
    @deck = deck
    @hand = hand
    @discard = discard
    @clank_cubes = clank_cubes
    @attack_points = attack_points
    @coins = coins
    @health = health
    @position = position
  end
end
