# frozen_string_literal: true

class CalculateVictoryPoints < Base
  def execute!
    gameplay_data.players.each do |player|
      player.victory_points = calculate_victory_points(player)
    end
    gameplay_data
  end

  private

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
    return 0 unless condtion['two_of'].present? && player.inventory.count { |c| c['name'] == condition['two_of'] } >= 2

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
      points
    end
  end

  def calculate_victory_points(player)
    points = 0
    points += player.coins
    points += full_deck_victory_points(player)
    points += player.inventory.sum { |card| card.fetch('victory_points', 0) }
    points
  end
end
