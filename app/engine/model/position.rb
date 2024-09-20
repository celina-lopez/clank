# frozen_string_literal: true

class Model::Position
  attr_accessor :current_position
  attr_reader :graph

  def initialize(current_position = 0, graph = Hash.new { |h, k| h[k] = {} if k.is_a?(Integer) })
    @current_position = current_position.to_i
    # TODO: do you need graph here??? maybe move this to map
    @graph = graph.deep_transform_keys(&:to_i).presence || build_graph(graph)
  end

  def self.from_json(json)
    game_engine::Model::Position.new(json['current_position'], json['graph'])
  end

  def next_to?(goal)
    graph[current_position].keys.include?(goal.to_i)
  end

  def edge_metadata(goal)
    edge = game_engine::Model::Position::EDGES.find do |x|
      x['x'] == current_position && x['y'] == goal.to_i
    end
    edge.fetch('metadata', {})
  end

  def current_position_tags
    @current_position_tags ||= tags(current_position)
  end

  def tags(goal)
    engine::Model::Position::MAP.find { |x| x['tile'] == goal.to_i }.fetch('tags', [])
  end

  private

  def build_graph(graph)
    raise NotImplementedError
  end
end
