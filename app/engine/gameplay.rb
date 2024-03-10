class Gameplay
  attr_accessor :players,
                :current_player,
                :map,
                :deck,
                :companion_deck,
                :monster_state

  def initialize( # rubocop:disable Metrics/ParameterLists
    current_player: nil, players: [],
    map: Map.new,
    deck: [],
    companion_deck: [],
    monster_state: []
  )
    @players = players
    @current_player = current_player || players.sample
    @map = map
    @deck = deck
    @companion_deck = companion_deck
    @monster_state = monster_state
  end

  def commit_action(action)
    action.execute(self)
  end
end
