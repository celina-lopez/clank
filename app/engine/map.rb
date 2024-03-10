class Map # rubocop:disable Style/Documentation
  attr_accessor :tiles,
                :edges

  def initialize(
    tiles:,
    edges:
  )
    @tiles = tiles
    @edges = edges
  end

  def self.start!
    tiles = YAML.load_file('config/game/tiles.yml')
    edges = YAML.load_file('config/game/edges.yml')
    new(tiles:, edges:)
  end
end
