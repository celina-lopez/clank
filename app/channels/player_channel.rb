class PlayerChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'player_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
