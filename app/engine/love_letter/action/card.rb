# frozen_string_literal: true

class LoveLetter::Action::Card < Action::Card
  def execute!
    play_card
    send(type)
    gameplay_data
  end

  def princess
    current_player.removed_from_round = true
    immediately_end_turn
  end

  def spy
    immediately_end_turn
  end

  alias countess spy

  def king
    current_player.trade_card_points = 1
  end

  def chancellor
    new_cards = gameplay_data.deck.deck.pop(2)
    current_player.deck.active.concat(new_cards)
    current_player.keep_card_points = 1
  end

  def prince
    current_player.choose_player_to_discard_points = 1
  end

  def handmaid
    current_player.protected_from_discard = true
    immediately_end_turn
  end

  def baron
    current_player.choose_player_to_compare_points = 1
  end

  def priest
    current_player.choose_player_to_reveal_card = 1
  end

  def guard
    current_player.choose_player_to_guess_card = 1
  end

  private

  def play_card
    card = current_player.deck.active.find { |c| c['name'] == type }
    current_player.deck.discard(card)
    gameplay_data.deck.discarded << card
  end

  def immediately_end_turn
    LoveLetter::Action::Game.new(gameplay_data, type: 'end_turn', value: nil).end_turn
  end
end
