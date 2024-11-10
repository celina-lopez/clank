# frozen_string_literal: true

class AeonsEnd::Action::Game < Action::Game
  def end_turn
    gameplay_data.next_player!
    return end_game! if gameplay_data.monster.dead? || gameplay_data.gravehold <= 0

    fullfill_immediate_actions
  end

  def start_game
    self.gameplay_data = game_engine::Model::Game.new(new_players: value[:players])
  end

  private

  def fullfill_immediate_actions
    # todo
  end
end
