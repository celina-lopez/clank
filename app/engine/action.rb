# frozen_string_literal: true

class Action
  attr_accessor :gameplay_data

  def initialize(gameplay_data)
    @gameplay_data = gameplay_data
  end

  def execute(type:, value:)
    klass = case type
            when Executeable::PLAYER_ACTIONS.include?(type)
              Action::Player
            when CARD_NAMES.include?(type)
              Action::Game
            when Executeable::CARD_ACTIONS.include?(type)
              Action::Card
            end
    klass.new(gameplay_data, value:, type:).execute!
  end
end
