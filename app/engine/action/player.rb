# frozen_string_literal: true

class Action::Player < Action::Base
  def buy_artifact
    item = BUYABLE_ITEMS.find_by { |x| x['name'] }
    current_player.coins -= item['cost']
    current_player.inventory << item
  end

  def buy_card
    card = gameplay_data.deck.active.find { |x| x['name'] == value }
    if card.present?
      discard_from_deck(card)
    else
      card = gameplay_data.marketplace.find { |x| x['name'] == value }
      card['total'] -= 1
    end
    redeem_card(card)
  end

  def move
    current_player.position.current_position = value
    # TODO: if certain cards are active, then some stuff is ignored
    edge_metadata = current_player.position.edge_metadata(value)
    current_player.move_points -= edge_metadata.fetch('move', 1)
    current_player.health -= edge_metadata.fetch('danger', 0)
  end

  def teleport
    current_player.position.current_position = value
  end

  def redeem_reward
    # TODO: value should be index
    reward = current_player.rewards[value]
    reward.each do |action_key, action_value|
      redeem_action_on_card(action_key, action_value)
    end
    current_player.rewards = []
  end

  private

  def redeem_cost(card)
    current_player.skill_points -= card['cost']
  end

  def pay_with_attack_points(card)
    current_player.attack_points -= card['health']
  end

  def redeem_card(card)
    pay_with_attack_points(card) if card['health'].present?
    redeem_cost(card) if card['cost'].present?
    card_on_acquire(card)
    return if card['health'].present? || !Base::DEVICE_CARD_NAMES.include?(card['name'])

    current_player.deck.discarded << card
  end

  def card_on_acquire(card)
    card.fetch('acquire', {}).each do |action_type, action_value|
      redeem_action_on_card(action_type, action_value)
    end
  end

  def redeem_action_on_card(action_type, action_value)
    Action::Card.new(gameplay_data, type: nil, value: action_value).send(action_type)
  end

  def discard_from_deck(card)
    return if card['name'] == 'goblin'

    gameplay_data.deck.destroy!(card)
  end
end
