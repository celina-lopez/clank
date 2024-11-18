# frozen_string_literal: true

class LoveLetter::Action::Player < Action::Player
  def redeem_reward
    indexes = value.split(',').map(&:to_i)
    reward = current_player.rewards.dig(*indexes)
    reward.each do |action_key, action_value|
      redeem_action_on_card(action_key, action_value)
    end
    current_player.rewards.delete_at(indexes.first)
  end

  def redeem_action_on_card(action_type, action_value)
    history << { type: action_type, value: action_value, player_index: current_player.index }
    card_engine = Clank::Action::Card.new(gameplay_data, type: action_type, value: action_value)
    card_engine.send(action_type)
    history.concat(card_engine.history)
  end

  def discard_from_deck(card)
    return if card['name'] == 'goblin'

    gameplay_data.deck.destroy!(card)
  end
end
