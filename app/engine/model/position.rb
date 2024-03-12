# frozen_string_literal: true

class Model::Position
  EDGES = YAML.load_file('config/game/edges.yml')['map_1']
  attr_accessor :current_position

  def initialize
    @current_position = 0
  end

  def distance_to(goal)
    distances = Hash.new(Float::INFINITY)
    distances[current_position] = 0
    queue = [current_position]
    calculate_distance_with_queue(queue, distances, goal)
    distances[goal]
  end

  def next_to?(goal)
    graph[current_position].keys.include?(goal)
  end

  private

  def graph
    return @graph if defined?(@graph)

    @graph = Hash.new { |h, k| h[k] = {} }
    EDGES.each do |edge|
      from = edge['x']
      to = edge['y']
      weight = edge.fetch('metdata', {}).fetch('move', 1)
      @graph[from][to] = weight
      @graph[to][from] = weight
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
