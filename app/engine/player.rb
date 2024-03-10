class Player # rubocop:disable Style/Documentation
  attr_accessor :deck,
                :hand,
                :discard,
                :clank_cubes,
                :attack_points,
                :coins,
                :health,
                :position,
                :clank_reserve,
                :action_inventory

  STARTING_CLANK_CUBES = { 0 => 3, 1 => 2, 2 => 1, 3 => 0 }.freeze

  def initialize( # rubocop:disable Metrics/ParameterLists
    deck:,
    hand:,
    discard:,
    clank_cubes: 0,
    attack_points: 0,
    coins: 7,
    health: 10,
    position: [0, 0],
    clank_reserve: 30
  )
    @deck = deck
    @hand = hand
    @action_inventory = { move: 0, attack: 0, skill_points: 0, draw: 0 }
    @discard = discard
    @clank_cubes = clank_cubes
    @attack_points = attack_points
    @coins = coins
    @health = health
    @position = position
    @clank_reserve = clank_reserve
  end

  def self.start!(turn_order)
    deck = Deck.from_yaml(:starter).shuffle
    new(
      hand: deck.draw(5),
      deck: deck.cards,
      clank_cubes: STARTING_CLANK_CUBES[turn_order],
      clank_reserve: 30 - STARTING_CLANK_CUBES[turn_order]
    )
  end

  def draw(number = 1)
    number.times do
      hand.cards << draw_one_card
    end
  end

  def draw_one_card
    card = deck.draw
    if card.nil?
      shuffle_discard_into_deck
      card = deck.draw
    end
    card
  end

  def shuffle_discard_into_deck
    deck.cards = discard.shuffle
    self.discard = Deck.new([])
  end

  def add_attack(value)
    self.attack_points += value
  end

  def discard_card(card)
    hand.delete(card)
    discard << card
  end

  def clank_cube(value)
    self.clank_reserve -= value
    self.clank_cubes += value
  end

  def move(value)
    self.position = value
  end

  def coin(value)
    self.coins += value
  end

  def heal(value = 1)
    self.health += value
  end

  def damage(value = 1)
    self.health -= value
  end
end
