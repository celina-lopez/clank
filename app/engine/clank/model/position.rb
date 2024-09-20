# frozen_string_literal: true

class Clank::Model::Position < Model::Position
  EDGES = YAML.load_file('config/game/edges.yml')['map_1']
  MAP = YAML.load_file('config/game/maps.yml')['map_1']

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

  private

  def build_graph(graph)
    EDGES.each do |edge|
      from = edge['x']
      to = edge['y']
      weight = edge.fetch('metdata', {}).fetch('move', 1)
      graph[from][to] = weight
      graph[to][from] = weight
    end
    graph
  end
end
