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

  add_alias :teleport, :move

  private

  def reedem_cost(card)
    current_player.skill_points -= card['cost'] if card['cost'].present?
  end

  def reedeem_health(card)
    current_player.attack_points -= card['health'] if card['health'].present?
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
    reedeem_health(card)
    reedem_cost(card)
    card.fetch('acquire', {}).each do |action_type, action_value|
      redeem_action_on_card(action_type, action_value)
    end
    if card['health'].present?

      card['actions'].one? ? redeem_monster_reward : add_reward_options
    else
      current_player.deck.discarded << card
    end
  end

  def redeem_action_on_card(action_type, action_value)
    Action::Card.new(gameplay_data, type: nil, value: action_value).send(action_type)
  end

  def redeem_monster_reward
    (rewards = monster.fetch('actions', []).first).each_key do |key|
      redeem_action_on_card(key, rewards[key])
    end
  end

  def add_reward_options
    # TODO: choose rewards?
    current_player.rewards = monster.fetch('actions', [])
  end

  def monster
    @monster ||= Validation::MONSTER_CARDS.find { |card| card['name'] == value }
  end

  def discard_from_deck(card)
    return unless card.present?
    return if goblin?(card)

    gameplay_data.deck.destroy!(card)
  end
end
