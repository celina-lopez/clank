# frozen_string_literal: true

class Model::Dragon
  attr_accessor :position, :clank

  MAX_CLANK = 28
  MAX_POSITION = 6

  def self.from_json(json)
    Model::Dragon.new(**json.symbolize_keys)
  end

  def initialize(clank: MAX_CLANK, position: 0, num_players: nil)
    @position = if num_players >= 4
                  0
                elsif num_players == 3
                  1
                elsif num_players == 2
                  2
                else
                  position
                end
    @clank = clank
  end
end
