# frozen_string_literal: true

class AeonsEnd::Model::Player < Model::Player
  attr_accessor :coins, :rewards, :deck
  attr_reader :clank

  MAX_HEALTH = 10

  def self.from_json(json)
    AeonsEnd::Model::Player.new(
      json['index'],
      deck: Clank::Model::Deck.from_json(json['deck']),
      **json.symbolize_keys.reject { |k, _v| %i[index deck game_engine].include?(k) }
    )
  end

  def initialize( # rubocop:disable Metrics/ParameterLists
    index = 0,
    name: nil,
    health: nil,
    deck: nil,
    attack_points: 0,
    slots: 0,
    filled_slots: 0,
    skill_points: 0,
    rewards: [],
    victory_points: 0
  )
    @index = index || 0
    @name = name
    @slots = slots
    @filled_slots = filled_slots
    @deck = deck || Clank::Model::Deck.new(Clank::Base::STARTING_DECK_CARDS)
    @attack_points = attack_points || 0
    @health = health || MAX_HEALTH
    @rewards = rewards || []
    @skill_points = skill_points || 0
    @victory_points = victory_points
  end
end
