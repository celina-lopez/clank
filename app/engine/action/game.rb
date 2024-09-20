# frozen_string_literal: true

class Action::Game < Action::Base
  def start_game
    self.gameplay_data = game_engine::Model::Game.new(new_players: value[:players],
                                                      map: game_engine::Model::Map.new(map_type: value[:map_type]))
  end

  private

  def end_game!
    history << { type: 'end_game' }
    gameplay_data.end_game = true
    CalculateVictoryPoints.new(gameplay_data).execute!
  end
end
