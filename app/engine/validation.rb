# frozen_string_literal: true

class Validation
  class TypeUnknown < StandardError; end

  attr_reader :gameplay_data

  def initialize(gameplay_data)
    @gameplay_data = gameplay_data
  end

  def valid?(type:, value:)
    raise TypeUnknown unless Executeable::ACTIONS.include?(type)

    klass = case type
            when Executeable::PLAYER_ACTIONS.include?(type)
              Validation::Player
            when Executeable::CARD_ACTIONS.include?(type)
              Validation::Card
            when Executeable::GAME_ACTIONS.include?(type)
              Validation::Game
            end
    klass.new(gameplay_data, value:, type:).valid?
  end

  def errors
    raise 'Not implemented'
  end
end
