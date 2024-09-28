# frozen_string_literal: true

RSpec.configure do |config|
  # Use same seed as RSpec in order to be able to reproduce test failures with a given seed
  Faker::Config.random = Random.new(config.seed)
end
