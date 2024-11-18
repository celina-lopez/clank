# frozen_string_literal: true

class Model::Player < Base
  attr_accessor :move_points, :inventory,
                :skill_points, :discard_number, :victory_points
  attr_reader :health, :index, :attack_points, :clank, :name

  def initialize(index, **kwargs)
    @index = index
    @name = kwargs[:name]
    @inventory = kwargs[:inventory] || []
    @attack_points = kwargs[:attack_points] || 0
    @health = kwargs[:health] || game_engine::Model::Player::MAX_HEALTH
    @move_points = kwargs[:move_points] || 0
    @skill_points = kwargs[:skill_points] || 0
    @victory_points = kwargs[:victory_points]
  end

  def health=(value)
    @health = [value, game_engine::Model::Player::MAX_HEALTH].min
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
