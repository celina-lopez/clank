# frozen_string_literal: true

class Action::Player < Action::Base
  def attack
    # TODO: in validation, make sure card is active!
    # TODO: for monster: again i named this differently, also some awards you can chose either or
    current_player.attack_points = current_player.attack_points - monster['health']
    monster['actions'].one? ? redeem_monster_reward : choose_reward
    discard!(monster_card)
  end

  def buy_artifact
    item = BUYABLE_ITEMS.find_by { |x| x['name'] }
    current_player.coins -= item['cost']
    current_player.inventory << item
  end

  def buy_card
    card = take_card
    current_player.skill_points -= card['cost']
    current_player.discard_deck << card
    card.fetch('acquire', []).each { |action, action_value| action_card(action, action_value) }
  end

  def move
    current_player.position.current_position = value
    current_player.move_points -= current_player.position.distance_to(value)
  end

  def teleport
    move
  end

  private

  def take_card # rubocop:disable Metrics/AbcSize
    card = gameplay_data.deck.active.find { |x| x['name'] == value }
    gameplay_data.deck.destroy!(card) if card.present?
    card = gameplay_data.marketplace.find { |x| x['name'] == value } if card.nil?
    card['total'] -= 1
    card
  end

  def action_card(action_type, action_value)
    Action::Card.new(gameplay_data, type: action_type, value: action_value).execute
  end

  def redeem_monster_reward
    (rewards = monster.fetch('actions', []).first).each_key do |key|
      action_card(key, rewards[key])
    end
  end

  def choose_reward
    current_player.rewards = monster.fetch('actions', [])
    # need to think about this one...
  end

  def monster
    @monster ||= Validation::MONSTER_CARDS.find { |card| card['name'] == value }
  end

  def discard!(card)
    return if goblin?(card)

    gameplay_data.deck.discard(card)
  end
end
