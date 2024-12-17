# frozen_string_literal: true

class LoveLetter::Labeler < Labeler
  def label(history) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
    player = by_player(history)
    case history['type'].to_s
    when 'end_turn'
      "#{player} ended their turn"
    when 'start_game'
      "Started game with #{history['value']} player(s)"
    when 'choose_player_to_guess'
      value = history['value'].split(',')
      chosen_player = fetch_player(value[0])
      "#{player} guess that the #{chosen_player} has the #{value[1]} card"
    when 'discarded_princess'
      "#{player} discarded the princess card"
    when 'removed_from_round'
      "#{player} was removed from the round"
    when 'choose_player_to_reveal'
      "#{player} chose #{fetch_player(history['value'])} to reveal their card to them"
    when 'choose_player_to_discard'
      "#{player} chose #{fetch_player(history['value'])} to discard their card"
    when 'choose_player_to_compare'
      "#{player} chose #{fetch_player(history['value'])} to compare their card to"
    when 'keep_card'
      "#{player} kept their card"
    when 'trade_card'
      "#{player} traded their card with #{fetch_player(history['value'])}"
    else
      "#{player} used #{history['type'].to_s.humanize} card"
    end
  end
end
