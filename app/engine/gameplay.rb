class Gameplay # rubocop:disable Metrics/ClassLength
  attr_accessor :players,
                :current_player_index,
                :map,
                :deck,
                :reserve_deck,
                :monster_state,
                :active_cards,
                :discard

  STARTING_DECK = YAML.load_file('config/game/starting_deck.yml')

  def initialize( # rubocop:disable Metrics/ParameterLists
    map:,
    current_player_index: nil,
    players: [],
    deck:,
    discard: Deck.new([]),
    active_cards:,
    reserve_deck:,
    monster_state:, 
  )
    @players = players
    @current_player_index = current_player_index || rand(players.length - 1)
    @map = map
    @deck = deck
    @discard = discard
    @active_cards = active_cards
    @reserve_deck = reserve_deck
    @monster_state = monster_state
  end

  def commit_action(type:, value:)
    action = Action.new(type:, value:, state: self)
    action.execute
  end

  def current_player
    players[current_player_index]
  end

  def self.start!(num_players)
    deck = Deck.from_yaml(:starter).shuffle
    active_cards = Deck.new(deck.draw(5))
    new(
      players: num_players.times.map { |i| Player.start!(i) },
      map: Map.start!,
      deck:,
      active_cards:,
      reserve_deck: Deck.from_yaml(:reserve),
      monster_state: Dragon.new(cubes: num_players - 1)
    )
  end

  def draw
    card = deck.draw
    active_cards.cards << card
    card.immediate_actions.each do |action|
      commit_action(action)
    end
  end

  def dragon_cubes(value)
    monster_state.add_cubes(value)
  end

  def move(value)
    # if current_player.position, find edge is valid, has enough moves, etc
    current_player.move(value)
  end

  def teleport(value)
    # if current_player.position, find edge is valid, has enough moves, etc
    current_player.move(value)
  end

  def dragon_attack(value) # rubocop:disable Metrics/MethodLength
    cubes = []
    players.each_with_index do |player, idx|
      player.clank_cube.times do
        cubes << idx
      end
    end
    monster_state.cubes.times do
      cubes << :dragon
    end
    cubes.shuffle!
    cubes.pop(value).each do |cube|
      players[cube].damage if cube != :dragon
    end
  end

  def buy_card(value)
    card = active_cards.cards.find { |card| card.name == value }
    card = reserve_deck.cards.draw.find { |card| card.name == value } if card.nil?
    return unless card.cost <= current_player.action_inventory[:skill_points]

    current_player.action_inventory[:skill_points] -= card.cost
    card.on_acquire.each do |action|
      commit_action(action)
    end
    current_player.discard << card
  end

  def end_turn
    self.current_player_index = (current_player_index + 1) % players.length
    players.each do |player|
      player.action_inventory = { move: 0, attack: 0, skill_points: 0, draw: 0 }
      player.draw(5)
    end
    return unless active_cards.length < 5

    new_cards = deck.draw(5 - active_cards.length)
    active_cards.concat(new_cards)
    new_cards.each do |card|
      card.immediate_actions.each do |action|
        commit_action(action)
      end
    end
    return unless end_game?

    end_game!
  end

  def end_game?
    players.any? { |x| x.position == [10, 10] }
  end

  def end_game!
    # calculate victory points, choose winner, fix below
    players.sample
  end
end
