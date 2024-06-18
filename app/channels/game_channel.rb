# frozen_string_literal: true

class GameChannel < ApplicationCable::Channel
  def subscribed
    game_id = params[:game_id]
    stream_from "game_channel_#{game_id}"
  end

  def receive(data)
    game = Game.find(params[:game_id])
    type, value, player_index = data.values_at('type', 'value', 'player_index')
    new_game_data = game.engine.execute(type:, value:, player_index:)
    json_data = JSON.parse(new_game_data.to_json)
    game.update!(data: json_data)
    ActionCable.server.broadcast("game_channel_#{game.id}", json_data.merge(last_log: game.history.last))
    # rescue StandardError => e
    # ActionCable.server.broadcast("game_channel_#{game.id}", { error: e.message })
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
