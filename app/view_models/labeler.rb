# frozen_string_literal: true

class Labeler
  class << self
    def label(history) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
      case history['type']
      when 'move'
        "Player #{history['player_index']} moved to tile #{history['value']}"
      when 'buy_card'
        "Player #{history['player_index']} acquired #{history['value'].humanize} card"
      when 'coins'
        "Player #{history['player_index']} gained #{history['value']} coin(s)"
      when 'end_turn'
        "Player #{history['player_index']} ended their turn"
      when 'dragon_attack'
        'Dragon Attacked!'
      when 'redeemed_reward'
        "Player #{history['player_index']} redeemed a reward"
      when 'move_points'
        "Player #{history['player_index']} gained #{history['value']} move point(s)"
      when 'health'
        "Player #{history['player_index']} gained #{history['value']} health"
      when 'start_game'
        "Started game with #{history['value']} player(s)"
      when 'buy_artifact'
        "Player #{history['player_index']} bought #{history['value'].humanize}"
      when 'play_all_cards'
        "Player #{history['player_index']} played their hand"
      when 'trash'
        "Player #{history['player_index']} trashed #{history['value']}"
      when 'redeem_reward'
        "Player #{history['player_index']} redeemed a reward"
      when 'redeem_inventory_item'
        "Player #{history['player_index']} used #{history['value'].humanize} from their inventory"
      when 'replace_card'
        "Player #{history['player_index']} replaced a card on the dungeon row"
      when 'dragon_clank'
        dragon_clank(history)
      else
        "Player #{history['player_index']} used #{history['type'].humanize} card"
      end
    end

    def dragon_clank(history)
      hits = history['value'].reject { |x| x == -1 }.tally
      message = hits.map { |player, count| "Player#{player} #{count} #{'time'.pluralize(count)}" }.join(', ')
      "Dragon hit #{message}!"
    end
  end
end
