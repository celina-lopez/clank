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
    add_skills_if_active_players(:trade_card_points)
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
    add_skills_if_active_players(:choose_player_to_compare_points)
  end

  def priest
    add_skills_if_active_players(:choose_player_to_reveal_card)
  end

  def guard
    add_skills_if_active_players(:choose_player_to_guess_card)
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

  def active_players
    gameplay_data.players.select do |player|
      !player.removed_from_round && !player.protected_from_discard && player.index != current_player_index
    end.any?
  end

  def add_skills_if_active_players(skill)
    if active_players
      current_player.public_send("#{skill}=", 1)
    else
      immediately_end_turn
    end
  end
end
