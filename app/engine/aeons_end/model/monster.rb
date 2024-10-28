# frozen_string_literal: true

class AeonsEnd::Model::Monster
  MONSTER_TYPES = %w[default].freeze
  def self.from_json(json)
    new(
      health: json['health'],
      type: json['type'],
      deck: AeonsEnd::Model::Deck.from_json(json['deck'])
    )
  end

  def initialize(
    health: 70,
    type: MONSTER_TYPES.first,
    deck: AeonsEnd::Model::Deck.new(AeonsEnd::Base::MONSTER_CARDS)
  )
    @health = health
    @type = type
    @deck = deck
  end
end
