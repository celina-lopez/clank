# frozen_string_literal: true

class AeonsEnd::Model::Monster
  attr_accessor :health, :type, :deck

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
    deck: AeonsEnd::Model::Deck.new(AeonsEnd::Base::MONSTER_CARDS, num_of_active_cards: 0)
  )
    @health = health
    @type = type
    @deck = deck
  end

  def dead?
    health <= 0
  end
end
