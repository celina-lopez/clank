class Action # rubocop:disable Style/Documentation
  attr_accessor :type, :value, :state

  def initialize(type:, value:, state:)
    @value = value
    @type = type
    @state = state
  end

  def current_player
    state.current_player
  end

  def execute
    case type
    when :draw, :add_attack, :clank_cube, :coin, :heal
      current_player.send(type, value)
    when :discard
      current_player.discard_card(value)
    when :buy_card, :teleport, :dragon_cubes, :move, :dragon_attack, :end_turn
      state.public_send(type, value)
    end
  end
end
