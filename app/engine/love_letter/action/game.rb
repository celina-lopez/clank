# rubocop:disable Metrics/AbcSize
# frozen_string_literal: true

class LoveLetter::Action::Game < Action::Game
  def start_game
    self.gameplay_data = game_engine::Model::Game.new(new_players: value[:players])
  end

  def end_turn
    if gameplay_data.deck.deck.empty?
      end_of_round!
      return
    end
    if end_game?
      gameplay_data.end_game = true
      return
    end
    loop do
      gameplay_data.next_player!
      break unless current_player.removed_from_round
    end
    drawn_card = gameplay_data.deck.deck.pop
    current_player.deck.active << drawn_card
    current_player.protected_from_discard = false
    current_player.revealed_card_to_player = nil
  end

  private

  def end_game?
    # TODO: count number of love tokens
    false
  end

  def end_of_round!
    gameplay_data.deck = LoveLetter::Model::Deck.new(LoveLetter::Base::CARDS, num_of_active_cards: 0)
    gameplay_data.setup_deck(gameplay_data.players.size)
    gameplay_data.players.each do |player|
      player.deck = LoveLetter::Model::Deck.new(active: gameplay_data.deck.deck.pop(1))
    end
  end
end

# rubocop:enable Metrics/AbcSize
