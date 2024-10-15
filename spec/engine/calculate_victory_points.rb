# frozen_string_literal: true

class CalculateVictoryPoints < Base
  def execute!
    raise NotImplementedError
  end

  def calculate_victory_points(player)
    raise NotImplementedError
  end
end
