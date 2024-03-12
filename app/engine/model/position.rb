# frozen_string_literal: true

class Model::Position < Model::Base
  EDGES = YAML.load_file('config/game/edges.yml')['map_1']
  attr_accessor :x, :y

  def initialize(x_position = 0, y_position = 0)
    @x = x_position
    @y = y_position
    super
  end

  def distance_to(goal)
    graph = Hash.new { |h, k| h[k] = {} }

    EDGES.each do |edge|
      from = edge['x']
      to = edge['y']
      graph[from][to] = 1
      graph[to][from] = 1 # Assuming the graph is undirected
    end

    distances = Hash.new(Float::INFINITY)
    distances[x] = 0

    queue = [x]

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

    distances[goal]
  end
end
