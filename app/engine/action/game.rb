# frozen_string_literal: true

class Action::Game < Action::Base
  MINIMUM_ACTIVE_CARDS = 6
  def end_turn
    rotate_player
    return unless gameplay_data.active_deck.length < MINIMUM_ACTIVE_CARDS

    restore_active_cards
  end

  def start_game
    gameplay_data.players = value.times.map { Player.new }
    gameplay_data.current_player = gameplay_data.players.first
  end

  def restore_active_cards
    cards_to_draw = MINIMUM_ACTIVE_CARDS - gameplay_data.active_cards.length
    drawn_cards = draw_cards(gameplay_data.deck, cards_to_draw)
    gameplay_data.active_cards = drawn_cards
    fullfill_immediate_actions(drawn_cards)
  end

  def fullfill_immediate_actions(newly_drawn_cards)
    immediate_actions = newly_drawn_cards.flat_map do |card|
      card.fetch('immediate_actions', [])
    end
    immediate_actions.each do |action|
      Action.new(self).execute(type: action['type'], value: action['value'])
    end
  end

  def rotate_player
    gameplay_data.current_player.active_deck = draw_cards(gameplay_data.current_player.deck, 5)
    gameplay_data.current_player = gameplay_data.players[gameplay_data.current_player_index + 1]
  end

  def draw_cards(deck, number)
    deck.pop(number)
  end
end
