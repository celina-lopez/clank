# frozen_string_literal: true

class GameChannel < ApplicationCable::Channel
  def subscribed
    game_id = params[:game_id]
    stream_from "game_channel_#{game_id}"
  end

  def receive(data)
    game = Game.find(params[:game_id])
    type, value, player_index = data.values_at('type', 'value', 'player_index')
    engine = game.engine
    new_game_data = engine.execute(type:, value:, player_index:)
    json_data = JSON.parse(new_game_data.to_json)
    game.update!(data: json_data)
    latest_logs = parsed_logs(engine.history)
    ActionCable.server.broadcast("game_channel_#{game.id}", json_data.merge(latest_logs:))
  rescue StandardError => e
    ActionCable.server.broadcast("game_channel_#{game.id}",
                                 { error: e.message, current_player_index: game.data['current_player_index'] })
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def parsed_logs(history)
    latest_logs = history.select { |item| item.is_a?(Hash) && item.keys.all? { |key| key.is_a?(Symbol) } }
    latest_logs.map do |log|
      Labeler.label(log.with_indifferent_access)
    end
  end
end
