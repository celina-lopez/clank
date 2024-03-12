# frozen_string_literal: true

class Action::Player < Action::Base
  MAX_HEALTH = 10
  def attack
    # TODO in validation, make sure card is active! 
    # TODO in basr, add current player 
    attack_points = current_player.attack_points
    monster_health = monster_card["health"] # i think i named this attack so change that
    # monster card find monster and if goblin dont discard 
    current_player.update(attack_points: attack_points - monster_health)
    if monster_card["rewards"].one? # again i named this differently, also some awards you can chose either or 
      (rewards = monster_card["rewards"].first).keys.each do |key| 
        Action::Cards.new(gameplay_data, type: key, value: rewards[key]).execute
      end
    else 
      Action::Cards.new(gameplay_data, type: "choose_reward", value: monster_card["rewards"])
    end
    discard!(monster_card)
  end

  def heal #put this in card actuon? 
    current_player.health += value
    if current_player.health > MAX_HEALTH
      current_player.health = MAX_HEALTH
    end
  end

  def buy
    # TODO: validation for posotjon and able to buy 
    item = BUYABLE_ITEMS.find_by {|x| x["name"]}
    current_player.coins -= item["cost"]
    current_player.inventory << item
  end 

  def discard!(card)
    return if goblin?(card)
    gameplay_data.active_cards.delete(card) # uhhh chrck if tbis works 
    gameplay_data.discard_deck << card
  end
end
