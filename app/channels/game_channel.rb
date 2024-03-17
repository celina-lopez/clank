# frozen_string_literal: true

class GameChannel < ApplicationCable::Channel
  def subscribed
    game_id = params[:game_id]
    stream_from "game_channel_#{game_id}"
  end

  def receive(data)
    game = Game.find(params[:game_id])
    engine = Engine.from_json(game.data)
    new_game_data = engine.execute(data)
    game.update!(data: new_game_data)
    ActionCable.server.broadcast("game_channel_#{game_id}", data)
  rescue StandardError => e
    ActionCable.server.broadcast("game_channel_#{game_id}", { error: e.message })
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
