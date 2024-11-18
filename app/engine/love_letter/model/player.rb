# frozen_string_literal: true

class LoveLetter::Model::Player < Model::Player
  attr_accessor :rewards, :deck

  def self.from_json(json)
    Clank::Model::Player.new(
      json['index'],
      deck: LoveLetter::Model::Deck.from_json(json['deck']),
      **json.symbolize_keys.reject { |k, _v| %i[index deck game_engine].include?(k) }
    )
  end

  def initialize(index = 0, deck: nil, rewards: [], **kwargs)
    super
    @deck = deck || LoveLetter::Model::Deck.new(LoveLetter::Base::DECK)
    @rewards = rewards || []
  end
end
