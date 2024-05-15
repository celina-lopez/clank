# frozen_string_literal: true

class Model::Position
  EDGES = YAML.load_file('config/game/edges.yml')['map_1']
  MAP = YAML.load_file('config/game/maps.yml')['map_1']
  attr_accessor :current_position
  attr_reader :graph

  def initialize(current_position = 0, graph = Hash.new { |h, k| h[k] = {} if k.is_a?(Integer) })
    @current_position = current_position.to_i
    @graph = graph.deep_transform_keys(&:to_i).presence || build_graph(graph)
  end

  def self.from_json(json)
    Model::Position.new(json['current_position'], json['graph'])
  end

  def distance_to(goal)
    distances = Hash.new(Float::INFINITY)
    distances[current_position] = 0
    queue = [current_position]
    calculate_distance_with_queue(queue, distances, goal.to_i)
    distances[goal.to_i]
  end

  def next_to?(goal)
    graph[current_position].keys.include?(goal.to_i)
  end
  # TODO: end tile, escape tile
  %w[marketplace depths crystal_cave end_tile escape_tile].each do |key|
    define_method "#{key}?" do
      metadata[key].present?
    end
  end

  def goal_metadata(value)
    MAP.find { |x| x['tile'] == value.to_i }.fetch('metadata', {})
  end

  def metadata
    @metadata ||= MAP.find { |x| x['tile'] == current_position }.fetch('metadata', {})
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

  # def calculate_distance_with_queue(queue, distances, goal)
  #   until queue.empty?
  #     current_node = queue.shift
  #     current_node = current_node.to_i

  #     break if current_node == goal

  #     graph[current_node].each do |neighbor, edge_weight|
  #       total_distance = distances[current_node] + edge_weight
  #       distances[neighbor] = total_distance
  #       queue << neighbor
  #     end
  #     # Sort the queue based on the distances to ensure nodes with the shortest distance are explored first
  #     queue.sort_by! { |node| distances[node] }
  #   end
  # end
end
