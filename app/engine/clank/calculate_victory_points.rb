# frozen_string_literal: true

class Clank::CalculateVictoryPoints < CalculateVictoryPoints
  def execute!
    gameplay_data.players.each do |player|
      gameplay_data.results[player.index] = []
      if player.position.depths?
        player.victory_points = 0
        next
      end
      player.victory_points = calculate_victory_points(player) unless player.position.depths?
      player.victory_points += 20 if player.position.current_position <= 0
      gameplay_data.results << { name: 'mastery_token', points: 20 } if player.position.current_position <= 0
    end
    gameplay_data
  end

  def custom_condition_points(player, condition)
    case condition['custom']
    when 'for_every_5_coins_add_victory_point'
      player.coins / 5
    when 'for_every_secret_tome_add_victory_point'
      player.deck.full_deck.count { |c| c['name'] == 'secret_tome' }
    else
      0
    end
  end

  def custom_two_of_condition_points(player, condition)
    return 0 unless condition['two_of'].present? && player.inventory.count do |c|
                      condition['two_of'].include?(c['name'])
                    end >= 2

    condition['victory_points']
  end

  def custom_has_condition_points(player, condition)
    return 0 unless condition['has'].present? && player.inventory.any? { |c| c['name'] == condition['has'] }

    condition['victory_points']
  end

  def full_deck_victory_points(player)
    player.deck.full_deck.sum do |card|
      points = card.fetch('victory_points', 0)
      card.fetch('conditions', []).each do |condition|
        next unless condition['type'] == 'victory'

        points += custom_condition_points(player, condition)
        points += custom_two_of_condition_points(player, condition)
        points += custom_has_condition_points(player, condition)
      end
      gameplay_data.results[player.index] << { name: card['name'], points: } unless points.zero?
      points
    end
  end

  def inventory_victory_points(player)
    player.inventory.sum do |card|
      points = card.fetch('victory_points', 0)
      gameplay_data.results[player.index] << { name: card['name'], points: } unless points.zero?
      points
    end
  end

  def calculate_victory_points(player)
    points = 0
    points += player.coins
    gameplay_data.results[player.index] << { name: 'coins', points: player.coins } unless player.coins.zero?
    points += full_deck_victory_points(player)
    points += inventory_victory_points(player)
    points
  end
end
