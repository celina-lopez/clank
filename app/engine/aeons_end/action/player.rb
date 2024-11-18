# frozen_string_literal: true

class AeonsEnd::Action::Player < Action::Player
  def redeem_reward
    indexes = value.split(',').map(&:to_i)
    reward = current_player.rewards.dig(*indexes)
    reward.each do |action_key, action_value|
      redeem_action_on_card(action_key, action_value)
    end
    current_player.rewards.delete_at(indexes.first)
  end

  private

  def remove_health(danger)
    current_player.health -= danger
  end

  def redeem_cost(card)
    current_player.skill_points -= card['cost'].to_i
  end

  def pay_with_attack_points(card)
    current_player.attack_points -= card['health']
  end

  def redeem_card(card)
    pay_with_attack_points(card) if card['health'].present?
    redeem_cost(card) if card['cost'].present?
    current_player.deck.discarded << card
  end

  def redeem_action_on_card(action_type, action_value)
    history << { type: action_type, value: action_value, player_index: current_player.index }
    card_engine = AeonsEnd::Action::Card.new(gameplay_data, type: action_type, value: action_value)
    card_engine.send(action_type)
    history.concat(card_engine.history)
  end

  def discard_from_deck(card)
    gameplay_data.deck.destroy!(card)
  end
end
