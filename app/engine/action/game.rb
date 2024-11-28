# frozen_string_literal: true

class Action::Game < Action::Base
  def end_game!
    history << { type: 'end_game' }
    gameplay_data.end_game = true
  end
end
