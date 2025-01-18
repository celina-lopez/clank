# frozen_string_literal: true

class AeonsEnd::Model::Player < Model::Player
  attr_accessor :coins, :rewards, :deck, :other_players_draws_cards_points, :breaches, :gem_skill_points

  MAX_HEALTH = 10

  def self.from_json(json)
    new(
      json['index'],
      deck: AeonsEnd::Model::Deck.from_json(json['deck']),
      **json.symbolize_keys.reject { |k, _v| %i[index deck game_engine].include?(k) }
    )
  end

  def initialize( # rubocop:disable Metrics/ParameterLists
    index = 0,
    deck: nil,
    breaches: {},
    slots: 0,
    rewards: [],
    other_players_draws_cards_points: 0,
    gem_skill_points: 0,
    **kwargs
  )
    super
    character = AeonsEnd::Base::STARTING_DECK_CARDS.find { |x| x['name'] == name }
    @index = index || 0
    @breaches = breaches.empty? ? initialize_breaches(character) : breaches
    @slots = slots || 0
    @gem_skill_points = gem_skill_points || 0
    @deck = deck || initialize_deck(character)
    @rewards = rewards || []
    @other_players_draws_cards_points = other_players_draws_cards_points || 0
  end

  def initialize_deck(character)
    AeonsEnd::Model::Deck.new(
      active: character['starting_hand'].flat_map { |x| [x] * x['total'] },
      deck: character['starting_deck'].flat_map { |x| [x] * x['total'] }
    )
  end

  def add_to_breach(value)
    breaches.each_value do |breach|
      if breach['item'].nil? && breach['opened'].zero?
        breach['item'] = value
        break
      end
    end
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

  def reset!
    @rewards = []
    @skill_points = 0
    @other_players_draws_cards_points = 0
  end
end
