# frozen_string_literal: true

class Labeler
  class << self
    def label(history, players = []) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
      player = players.fetch(history['player_index'].to_i, {})['name']
      case history['type'].to_s
      when 'move'
        "#{player} moved to tile #{history['value']}"
      when 'buy_card'
        "#{player} acquired #{history['value'].to_s.humanize} card"
      when 'coins'
        "#{player} gained #{history['value']} coin(s)"
      when 'end_turn'
        "#{player} ended their turn"
      when 'dragon_attack'
        "Dragon hit #{players[history['value']]['name']}!"
      when 'redeemed_reward'
        "#{player} redeemed a reward"
      when 'move_points'
        "#{player} gained #{history['value']} move point(s)"
      when 'health'
        "#{player} gained #{history['value']} health"
      when 'start_game'
        "Started game with #{history['value']} player(s)"
      when 'buy_artifact'
        "#{player} bought #{history['value'].to_s.humanize}"
      when 'play_all_cards'
        "#{player} played their hand"
      when 'trash'
        "#{player} trashed #{history['value']}"
      when 'redeem_reward'
        "#{player} redeemed a reward"
      when 'redeem_inventory_item'
        "#{player} used #{history['value'].to_s.humanize} from their inventory"
      when 'replace_card'
        "#{player} replaced a card on the dungeon row"
      else
        "#{player} used #{history['type'].to_s.humanize} card"
      end
    end
  end
end
