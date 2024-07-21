# frozen_string_literal: true

class Labeler
  class << self
    def label(history) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
      case history['type'].to_s
      when 'move'
        "Player #{history['player_index']} moved to tile #{history['value']}"
      when 'buy_card'
        "Player #{history['player_index']} acquired #{history['value'].to_s.humanize} card"
      when 'coins'
        "Player #{history['player_index']} gained #{history['value']} coin(s)"
      when 'end_turn'
        "Player #{history['player_index']} ended their turn"
      when 'dragon_attack'
        "Dragon hit Player#{history['value']}!"
      when 'redeemed_reward'
        "Player #{history['player_index']} redeemed a reward"
      when 'move_points'
        "Player #{history['player_index']} gained #{history['value']} move point(s)"
      when 'health'
        "Player #{history['player_index']} gained #{history['value']} health"
      when 'start_game'
        "Started game with #{history['value']} player(s)"
      when 'buy_artifact'
        "Player #{history['player_index']} bought #{history['value'].to_s.humanize}"
      when 'play_all_cards'
        "Player #{history['player_index']} played their hand"
      when 'trash'
        "Player #{history['player_index']} trashed #{history['value']}"
      when 'redeem_reward'
        "Player #{history['player_index']} redeemed a reward"
      when 'redeem_inventory_item'
        "Player #{history['player_index']} used #{history['value'].to_s.humanize} from their inventory"
      when 'replace_card'
        "Player #{history['player_index']} replaced a card on the dungeon row"
      else
        "Player #{history['player_index']} used #{history['type'].to_s.humanize} card"
      end
    end
  end
end
