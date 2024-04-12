# frozen_string_literal: true

class Action::Player < Action::Base
  def buy_artifact
    item = BUYABLE_ITEMS.find_by { |x| x['name'] }
    current_player.coins -= item['cost']
    current_player.inventory << item
  end

  def buy_card
    card = take_card
    redeem_card(card)
  end

  def move
    current_player.position.current_position = value
    current_player.move_points -= current_player.position.distance_to(value)
  end

  alias teleport move

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
    current_player.skill_points -= card['cost'] if card['cost'].present?
  end

  def pay_with_attack_points(card)
    current_player.attack_points -= card['health']
  end

  def take_card
    card = gameplay_data.deck.active.find { |x| x['name'] == value }
    discard_from_deck(card)
    if card.nil?
      card = gameplay_data.marketplace.find { |x| x['name'] == value }
      card['total'] -= 1 if card.present?
    end
    card
  end

  def redeem_card(card)
    pay_with_attack_points(card) if card['health'].present?
    pay_with_attack_points(card) if card['health'].present?
    redeem_cost(card)
    card_on_acquire(card)
    return if card['health'].present?

    current_player.deck.discarded << card unless Base::DEVICE_CARD_NAMES.include?(card['name'])
  end

  def card_on_acquire(card)
    card.fetch('acquire', {}).each do |action_type, action_value|
      redeem_action_on_card(action_type, action_value)
    end
  end

  def redeem_action_on_card(action_type, action_value)
    Action::Card.new(gameplay_data, type: nil, value: action_value).send(action_type)
  end

  def add_reward_options
    # TODO: choose rewards, also could be anything
    current_player.rewards = monster.fetch('actions', [])
  end

  def monster
    @monster ||= Validation::MONSTER_CARDS.find { |card| card['name'] == value }
  end

  def discard_from_deck(card)
    return unless card.present?
    return if card['name'] == 'goblin'

    gameplay_data.deck.destroy!(card)
  end
end
