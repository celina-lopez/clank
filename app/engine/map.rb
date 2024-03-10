class Map # rubocop:disable Style/Documentation
  attr_accessor :tiles,
                :edges

  def initialize(
    tiles: [],
    edges: []
  )
    @tiles = tiles
    @edges = edges
  end
end
