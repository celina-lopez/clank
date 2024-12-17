# frozen_string_literal: true

class AeonEnd::Labeler < Labeler
  # TODO: Implement this
  def label(history)
    player = fetch_player(history['player_index'])
    "#{player}: #{history['type']}, #{history['value']}"
  end
end
