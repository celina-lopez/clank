# frozen_string_literal: true

def config_yaml(name)
  YAML.load_file(Rails.root.join('config', 'game', "#{name}.yml"))
end

class Base
  def game_engine
    @game_engine ||= self.class.game_engine
  end

  def self.game_engine
    name.deconstantize.deconstantize.constantize
  end

  attr_accessor :gameplay_data

  def initialize(gameplay_data = nil)
    @gameplay_data = gameplay_data
  end

  def current_player
    gameplay_data.players[current_player_index]
  end

  def current_player_index
    gameplay_data&.current_player_index
  end
end
