class Dragon
  attr_accessor :cubes

  def initialize(cubes: 0)
    @cubes = cubes
  end

  def add_cubes(value)
    self.cubes += value
  end
end
