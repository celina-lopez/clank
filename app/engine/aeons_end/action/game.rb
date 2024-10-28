# frozen_string_literal: true

class AeonsEnd::Action::Game < Action::Game
  def end_turn
    gameplay_data.next_player!
    return end_game! if gameplay_data.monster.dead? || gameplay_data.gravehold_health.zero?

    fullfill_immediate_actions
  end

  private

  def fullfill_immediate_actions
    # todo
  end
end
