# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
# frozen_string_literal: true

class LoveLetter::Action::Game < Action::Game
  def start_game
    self.gameplay_data = game_engine::Model::Game.new(new_players: value[:players])
  end

  def end_turn
    end_of_round! if end_of_round?
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
      victory_points_threshold = case gameplay_data.players.size
                                 when 2 then 6
                                 when 3 then 5
                                 when 4 then 4
                                 else 3
                                 end

      gameplay_data.players.any? { |player| player.victory_points.to_i >= victory_points_threshold }
    end

  def distribute_favor_tokens_with_empty_deck # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    highest_score = 0
    spy_players = []
    valid_players = gameplay_data.players.filter do |player|
      valid = !player.removed_from_round
      if valid
        highest_score = [player.deck.active.first['victory_points'], highest_score].max
        spy_players << player.index if player.deck.discarded.find { |card| card['name'] == 'spy' }
      end
      valid
    end
    valid_players.each do |player|
      player.victory_points ||= 0
      player.victory_points += 1 if player.deck.active.first['victory_points'] == highest_score
      player.victory_points += 1 if spy_players.one? && spy_players.include?(player.index)
    end
  end

  def end_of_round!
    if gameplay_data.deck.deck.empty?
      distribute_favor_tokens_with_empty_deck
    else
      gameplay_data.players.each do |player|
        player.victory_points ||= 0
        player.victory_points += 1 unless player.removed_from_round
      end
    end
    gameplay_data.deck = LoveLetter::Model::Deck.new(LoveLetter::Base::CARDS, num_of_active_cards: 0)
    gameplay_data.setup_deck(gameplay_data.players.size)
    gameplay_data.players.each do |player|
      player.deck = LoveLetter::Model::Deck.new(active: gameplay_data.deck.deck.pop(1))
      player.removed_from_round = false
    end
  end

  def end_of_round?
    return true if gameplay_data.deck.deck.empty?

    gameplay_data.players.filter(&:removed_from_round).size == (gameplay_data.players.size - 1)
  end
end

# rubocop:enable Metrics/AbcSize, Metrics/MethodLength
