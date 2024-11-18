# frozen_string_literal: true

class LoveLetter::Action::Game < Action::Game
  def start_game
    self.gameplay_data = game_engine::Model::Game.new(new_players: value[:players])
  end

  def end_turn
    gameplay_data.next_player!
  end
end
