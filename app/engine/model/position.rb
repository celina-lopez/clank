# frozen_string_literal: true

class Model::Position
  EDGES = YAML.load_file('config/game/edges.yml')['map_1']
  MAP = YAML.load_file('config/game/maps.yml')['map_1']
  attr_accessor :current_position

  def initialize(_current_position = 0)
    @current_position = 0
  end

  def self.from_json(json)
    Model::Position.new(json['current_position'])
  end

  def distance_to(goal)
    distances = Hash.new(Float::INFINITY)
    distances[current_position] = 0
    queue = [current_position]
    build_graph
    calculate_distance_with_queue(queue, distances, goal.to_i)
    distances[goal.to_i]
  end

  def next_to?(goal)
    build_graph
    graph[current_position].keys.include?(goal.to_i)
  end

  %w[marketplace depths].each do |key|
    define_method "#{key}?" do
      metadata[key].present?
    end
  end

  def metadata
    @metadata ||= MAP.find { |x| x == current_position }.fetch('metadata', {})
  end

  private

  def graph
    @graph ||= Hash.new { |h, k| h[k] = {} if k.is_a?(Integer) }
  end

  def build_graph
    EDGES.each do |edge|
      from = edge['x']
      to = edge['y']
      weight = edge.fetch('metdata', {}).fetch('move', 1)
      graph[from][to] = weight
      graph[to][from] = weight
    end
  end

  def calculate_distance_with_queue(queue, distances, goal)
    until queue.empty?
      current_node = queue.shift

      break if current_node == goal

      graph[current_node].each do |neighbor, edge_weight|
        total_distance = distances[current_node] + edge_weight
        distances[neighbor] = total_distance
        queue << neighbor
      end
      # Sort the queue based on the distances to ensure nodes with the shortest distance are explored first
      queue.sort_by! { |node| distances[node] }
    end
  end
end
