# frozen_string_literal: true

class Action::Player < Action::Base
  def attack
    # TODO: in validation, make sure card is active!
    # TODO: for monster: again i named this differently, also some awards you can chose either or
    current_player.attack_points = current_player.attack_points - monster['health']
    monster['rewards'].one? ? redeem_monster_reward : choose_reward
    discard!(monster_card)
  end

  def buy_artifact
    item = BUYABLE_ITEMS.find_by { |x| x['name'] }
    current_player.coins -= item['cost']
    current_player.inventory << item
  end

  def buy_card
    card = gameplay_data.active_cards.find { |x| x['name'] == value }
    current_player.skill_points -= card['skill_point_cost']
    current_player.discard_deck << card
    gameplay_data.active_cards.delete(card) # check this works
  end

  def move
    raise NotImplemented
  end

  def teleport
    raise NotImplemented
  end

  private

  def redeem_monster_reward
    (rewards = monster['rewards'].first).each_key do |key|
      Action::Card.new(gameplay_data, type: key, value: rewards[key]).execute
    end
  end

  def choose_reward
    current_player.rewards = monster['rewards']
    # need to think about this one...
  end

  def monster
    @monster ||= Validation::MONSTER_CARDS.find { |card| card['name'] == value }
  end

  def discard!(card)
    return if goblin?(card)

    gameplay_data.active_cards.delete(card) # uhhh chrck if tbis works
    gameplay_data.discard_deck << card
  end
end
