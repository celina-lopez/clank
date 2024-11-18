# frozen_string_literal: true

class LoveLetter::Model::Game < Model::Game
  attr_accessor :deck

  def self.from_json(json)
    LoveLetter::Model::Game.new(
      deck: Clank::Model::Deck.from_json(json['deck']),
      players: json['players'].map { |p| Clank::Model::Player.from_json(p) },
      **json.symbolize_keys.reject { |k, _v| %i[deck players].include?(k) }
    )
  end

  def initialize(deck: LoveLetter::Model::Deck.new(LoveLetter::Base::DECK), **kwargs)
    super
    @deck = deck
  end
end
