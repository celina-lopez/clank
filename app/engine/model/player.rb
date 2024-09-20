# frozen_string_literal: true

class Model::Player < Base
  attr_accessor :move_points, :inventory,
                :skill_points, :discard_number, :victory_points
  attr_reader :health, :index, :attack_points, :clank, :name

  def initialize(**args)
    @index = args[:index] || 0
    @name = args[:name]
    @inventory = args[:inventory] || []
    @attack_points = args[:attack_points] || 0
    @health = args[:health] || game_engine::MAX_HEALTH
    @move_points = args[:move_points] || 0
    @skill_points = args[:skill_points] || 0
    @victory_points = args[:victory_points]
  end

  def health=(value)
    @health = [value, game_engine::MAX_HEALTH].min
  end

  def attack_points=(value)
    @attack_points = value
    return unless @attack_points.negative?

    @attack_points = 0
  end

  def dead?
    health.negative?
  end
end
