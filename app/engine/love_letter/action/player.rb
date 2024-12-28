# frozen_string_literal: true

class LoveLetter::Action::Player < Action::Player
  # TODO: history.concat(card_engine.history)
  def trade_card
    chosen_player = find_player(value)
    current_player_deck = current_player.deck.active.dup
    current_player.deck.active = chosen_player.deck.active
    chosen_player.deck.active = current_player_deck
    immediately_end_turn
  end

  def keep_card # rubocop:disable Metrics/AbcSize
    card_to_keep = current_player.deck.active.find { |x| x['name'] == value }
    current_player.deck.active.delete(card_to_keep)
    put_at_bottom_of_deck = current_player.deck.active.pop(2)
    gameplay_data.deck.deck.concat(put_at_bottom_of_deck)
    current_player.deck.active = [card_to_keep]
    immediately_end_turn
  end

  def choose_player_to_discard # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    chosen_player = find_player(value)
    discarded_card = chosen_player.deck.active.pop
    if discarded_card['name'] == 'princess'
      history << { type: 'discarded_princess', value: chosen_player.index, player_index: current_player.index }
      chosen_player.removed_from_round = true
      immediately_end_turn
      return
    end
    new_card = gameplay_data.deck.deck.pop
    new_card = gameplay_data.deck.active.pop if new_card.nil?
    chosen_player.deck.active << new_card if new_card.present?
    immediately_end_turn
  end

  def choose_player_to_compare # rubocop:disable Metrics/AbcSize
    chosen_player = find_player(value)
    other_player_card = chosen_player.deck.active.first
    current_player_card = current_player.deck.active.first
    current_player.revealed_card_to_player = { index: chosen_player.index, card: other_player_card }
    if other_player_card['victory_points'] > current_player_card['victory_points']
      history << { type: 'removed_from_round', value: current_player.index, player_index: current_player.index }
      current_player.removed_from_round = true
    elsif other_player_card['victory_points'] < current_player_card['victory_points']
      history << { type: 'removed_from_round', value: chosen_player.index, player_index: current_player.index }
      chosen_player.removed_from_round = true
    end
    immediately_end_turn
  end

  def choose_player_to_reveal
    chosen_player = find_player(value)
    current_player.revealed_card_to_player = { index: chosen_player.index, card: chosen_player.deck.active.first }
    immediately_end_turn
  end

  def choose_player_to_guess
    player_index, card_name = value.split(',')
    chosen_player = find_player(player_index)
    chosen_card = chosen_player.deck.active.find { |card| card['name'] == card_name }
    unless chosen_card.nil?
      history << { type: 'removed_from_round', value: chosen_player.index, player_index: current_player.index }
      chosen_player.removed_from_round = true
    end
    immediately_end_turn
  end

  private

  def immediately_end_turn
    LoveLetter::Action::Game.new(gameplay_data, type: 'end_turn', value: nil).end_turn
  end

  def find_player(index)
    gameplay_data.players.find { |player| player.index.to_i == index.to_i }
  end
end
