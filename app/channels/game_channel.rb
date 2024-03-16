# frozen_string_literal: true

class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'game_channel'
  end

  def receive(data)
    ActionCable.server.broadcast('game_channel', data)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
