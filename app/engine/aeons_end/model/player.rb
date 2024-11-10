# frozen_string_literal: true

class AeonsEnd::Model::Player < Model::Player
  attr_accessor :coins, :rewards, :deck

  MAX_HEALTH = 10

  def self.from_json(json)
    AeonsEnd::Model::Player.new(
      json['index'],
      deck: AeonsEnd::Model::Deck.from_json(json['deck']),
      **json.symbolize_keys.reject { |k, _v| %i[index deck game_engine].include?(k) }
    )
  end

  def initialize( # rubocop:disable Metrics/ParameterLists, Lint/MissingSuper
    index = 0,
    name: nil,
    health: nil,
    deck: nil,
    attack_points: 0,
    breaches: {},
    slots: 0,
    skill_points: 0,
    rewards: []
  )
    character = AeonsEnd::Base::STARTING_DECK_CARDS.find { |x| x['name'] == name }
    @index = index || 0
    @name = name
    @breaches = breaches.empty? ? initialize_breaches(character) : breaches
    @slots = slots || 0
    @deck = deck || initialize_deck(character)
    @attack_points = attack_points || 0
    @health = health || MAX_HEALTH
    @rewards = rewards || []
    @skill_points = skill_points || 0
  end

  def initialize_deck(character)
    AeonsEnd::Model::Deck.new(
      active: character['starting_hand'].flat_map { |x| [x] * x['total'] },
      deck: character['starting_deck'].flat_map { |x| [x] * x['total'] }
    )
  end

  def initialize_breaches(character)
    data = character['breaches']
    {
      first: {
        item: nil,
        opened: data['first']
      },
      second: {
        item: nil,
        opened: data['second']
      },
      third: {
        item: nil,
        opened: data['third']
      },
      fourth: {
        item: nil,
        opened: data['fourth']
      }
    }
  end
end
