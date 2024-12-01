# frozen_string_literal: true

class LoveLetter::Model::Player < Model::Player
  attr_accessor :rewards, :deck, :removed_from_round, :trade_card_points, :keep_card_points,
                :choose_player_to_discard_points, :protected_from_discard, :choose_player_to_compare_points,
                :choose_player_to_reveal_card, :choose_player_to_guess_card,
                :revealed_card_to_player

  def self.from_json(json)
    LoveLetter::Model::Player.new(
      json['index'],
      deck: LoveLetter::Model::Deck.from_json(json['deck']),
      **json.symbolize_keys.reject { |k, _v| %i[index deck game_engine].include?(k) }
    )
  end

  def initialize( # rubocop:disable Metrics/MethodLength
    index = 0,
    deck: nil,
    rewards: [],
    removed_from_round: false,
    trade_card_points: 0,
    keep_card_points: 0,
    choose_player_to_discard_points: 0,
    protected_from_discard: false,
    choose_player_to_compare_points: 0,
    choose_player_to_reveal_card: 0,
    choose_player_to_guess_card: 0,
    revealed_card_to_player: nil,
    **kwargs
    )
    super
    @deck = deck || LoveLetter::Model::Deck.new(LoveLetter::Base::CARDS)
    @rewards = rewards || []
    @removed_from_round = removed_from_round
    @trade_card_points = trade_card_points
    @keep_card_points = keep_card_points
    @choose_player_to_discard_points = choose_player_to_discard_points
    @protected_from_discard = protected_from_discard
    @choose_player_to_compare_points = choose_player_to_compare_points
    @choose_player_to_reveal_card = choose_player_to_reveal_card
    @choose_player_to_guess_card = choose_player_to_guess_card
    @revealed_card_to_player = revealed_card_to_player
  end

  def reset!
    @choose_player_to_discard_points = 0
    @choose_player_to_compare_points = 0
    @choose_player_to_reveal_card = 0
    @choose_player_to_guess_card = 0
    @trade_card_points = 0
    @keep_card_points = 0
  end

  def protected_from_discard?
    protected_from_discard
  end
end
