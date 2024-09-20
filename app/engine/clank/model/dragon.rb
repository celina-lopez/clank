# frozen_string_literal: true

class Clank::Model::Dragon
  attr_reader :clank, :position

  MAX_CLANK = 24
  POSTION_ARRAY = [2, 2, 3, 3, 4, 4, 5].freeze

  def self.from_json(json)
    new(**json.symbolize_keys)
  end

  def initialize(clank: MAX_CLANK, position: 0, num_players: nil) # rubocop:disable Metrics/MethodLength
    @position = if num_players.nil?
                  position
                elsif num_players >= 4
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

  def clank=(value)
    @clank = [value, MAX_CLANK].min
  end

  def position=(value)
    @position = [value, POSTION_ARRAY.length - 1].min
  end

  def num_of_hits
    POSTION_ARRAY[position]
  end
end
