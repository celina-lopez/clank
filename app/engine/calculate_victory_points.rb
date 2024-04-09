# frozen_string_literal: true

class CalculateVictoryPoints < Base
  def execute!
    gameplay_data.players.each do |player|
      player.victory_points = calculate_victory_points(player)
    end
  end

  private

  def calculate_victory_points(player)
    points = 0
    points += player.coins
    full_deck = player.deck.full_deck
    full_deck.each do |card|
      points += card['victory_points'] if card['victory_points'].present?
      card.fetch('conditions', []).each do |condition|
        if condition['type'] == 'victory'
          if condition['custom'] == 'for_every_5_coins_add_victory_point'
            points += player.coins / 5
          elsif condition['custom'] == 'for_every_secret_tome_add_victory_point'
            points += full_deck.count { |c| c['name'] == 'secret_tome' }
          elsif condtion['two_of'].present? && player.inventory.count { |c| c['name'] == condition['two_of'] } >= 2
            points += condition['victory_points']
          elsif condition['has'].present? && player.inventory.any? { |c| c['name'] == condition['has'] }
            points += condition['victory_points']
          end
        end
      end
    end
    player.inventory.each do |card|
      points += card['victory_points'] if card['victory_points'].present?
    end
    points
  end
end
