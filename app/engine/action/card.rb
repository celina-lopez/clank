# frozen_string_literal: true

class Action::Card < Action::Base
  def execute!
    if card.nil?
      send(type)
      return gameplay_data
    end
    redeem_card_rewards
  end

  def card
    @card ||= game_engine::Base::CARDS.find { |data| data['name'] == type }
  end

  %i[cards health attack_points move_points skill_points].each do |type|
    define_method(type) do |v = value|
      history << { type:, value: v, player_index: current_player_index }
      current_player.public_send("#{type}=", current_player.public_send(type) + v)
    end
  end

  def draw(val = value)
    current_player.deck.draw(val)
  end
end
