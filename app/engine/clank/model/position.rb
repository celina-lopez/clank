# frozen_string_literal: true

class Clank::Model::Position < Model::Position
  def end_tile?
    current_position == -4
  end

  def escape_tile?
    current_position <= 0
  end

  %w[marketplace depths crystal_cave].each do |key|
    define_method "#{key}?" do
      current_position_tags.include?(key)
    end
  end
end
