# frozen_string_literal: true

class AeonsEnd::Model::Monster
  attr_accessor :health, :type, :deck, :unleash_points, :unleash_deck

  MONSTER_TYPES = %w[default].freeze
  def self.from_json(json)
    new(
      deck: AeonsEnd::Model::Deck.from_json(json['deck']),
      unleash_deck: AeonsEnd::Model::Deck.from_json(json['unleash_deck']),
      **json.symbolize_keys.reject { |k, _v| %i[deck unleash_deck].include?(k) }
    )
  end

  def initialize(
    health: 70,
    type: MONSTER_TYPES.first,
    deck: AeonsEnd::Model::Deck.new(AeonsEnd::Base::MONSTER_CARDS, num_of_active_cards: 0),
    unleash_deck: AeonsEnd::Model::Deck.new(AeonsEnd::Base::MONSTER_CARDS, num_of_active_cards: 0), # TODO: update
    unleash_points: 0
  )
    @health = health
    @type = type
    @deck = deck
    @unleash_points = unleash_points
    @unleash_deck = unleash_deck
  end

  def dead?
    health <= 0
  end
end
