# frozen_string_literal: true

class LoveLetter::Labeler
  class << self
    def label(history, players = [])
      player = players.fetch(history['player_index'].to_i, {})['name']
      case history['type'].to_s
      when 'end_turn'
        "#{player} ended their turn"
      when 'start_game'
        "Started game with #{history['value']} player(s)"
      when 'choose_player_to_guess'
        value = history['value'].split(',')
        chosen_player = players.fetch(value[0].to_i, {})['name']
        "#{player} guess that the #{chosen_player} has the #{value[1]} card"
      when 'discarded_princess'
        "#{player} discarded the princess card"
      when 'removed_from_round'
        "#{player} was removed from the round"
      when 'choose_player_to_reveal'
        "#{player} chose #{players.fetch(history['value'].to_i, {})['name']} to reveal their card to them"
      else
        "#{player} used #{history['type'].to_s.humanize} card"
      end
    end
  end
end
