# frozen_string_literal: true

class Action::Game < Action::Base
  def end_turn
    rotate_player
    restore_active_cards
  end

  def start_game
    Model::Game.new(num_players: value)
  end

  private

  def restore_active_cards
    gameplay_data.active_cards = drawn_cards
    # TODO; fix
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
