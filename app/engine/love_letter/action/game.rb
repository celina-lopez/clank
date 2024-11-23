# frozen_string_literal: true

class LoveLetter::Action::Game < Action::Game
  def start_game
    self.gameplay_data = game_engine::Model::Game.new(new_players: value[:players])
  end

  def end_turn
    end_of_round! if gameplay_data.deck.active.empty?
    gameplay_data.end_game = true if end_game?
    gameplay_data.next_player!
    drawn_card = gameplay_data.deck.active.pop
    current_player.deck.active << drawn_card
    current_player.protected_from_discard = false
  end

  private

  def end_of_round!
    gameplay_data.deck = LoveLetter::Model::Deck.new(LoveLetter::Base::CARDS, num_of_active_cards: 0)
    gameplay_data.setup_deck(gameplay_data.players.size)
    gameplay_data.players.each do |player|
      player.deck = LoveLetter::Model::Deck.new(active: gameplay_data.deck.deck.pop(1))
    end
  end
end
