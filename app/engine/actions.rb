class Action # rubocop:disable Style/Documentation
  attr_accessor :value

  def initialize(value)
    @value = value
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
