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
    when :player_draw
      current_player.draw(value)
    when :add_attack
      current_player.add_attack(value)
    when :discard
      current_player.discard_card(value)
    when :clank_cube
      current_player.clank_cube(value)
    when :draw
      state.draw(value)
    when :buy_card
      state.buy_card(value)
    when :teleport
      state.teleport(value)
    when :dragon_cubes
      state.dragon_cubes(value)
    when :coin
      current_player.coin(value)
    when :heal
      current_player.heal(value)
    when :move
      state.move(value)
    when :end
      state.end_turn
    when :dragon_attack
      state.dragon_attack
    end
end

class DrawAction < Action; end

class AttackAction < Action; end

class DiscardAction < Action; end

class TrashAction < Action; end

class TeleportAction < Action; end

class DragonCubesAction < Action; end

class CoinAction < Action; end

class HealAction < Action; end

class MoveAction < Action; end

class ClankAction < Action; end

class EndAction < Action; end
