# frozen_string_literal: true

class Validation::Player < Validation::Base
  def attack?
    v = current_player.attack_points >= value
    errors << 'Not enough attack points' unless v
    v
  end

  def buy?
    # TODO: make this better for certain artificats
    errors << 'Not in marketplace' unless current_player.position.marketplace?
    v = current_player.coins >= value && current_player.position.marketplace?
    return v if v

    errors << "Need #{current_player.coins - value} coins" unless v
    v
  end

  def buy_card?
    card = CARDS.find { |x| x['name'] == value }
    errors << 'Card not found' unless card
    if card['cost'].present?
      v = current_player.skill_points >= card['cost'].to_i
      return v if v

      errors << "Need #{current_player.skill_points - card['cost']} more skill points"
    elsif card['health'].present?
      v = current_player.attack_points >= card['health'].to_i
      return v if v

      errors << "Need #{current_player.attack_points - card['health']} more attack points"
    end
  end

  def move?
    # TODO: still need to check locks
    # TODO: health
    distance_to = current_player.position.distance_to(value)
    v = distance_to <= current_player.move_points
    return v if v

    errors << "Need #{distance_to - current_player.move_points}" unless v
  end

  def teleport?
    errors << 'Not next to tile' unless current_player.position.next_to?(value)
    v = current_player.position.next_to?(value) && current_player.teleport.positive?
    return v if v

    errors << 'No teleport availabile' unless v
  end
end
