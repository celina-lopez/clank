# frozen_string_literal: true

class Action::Card < Action::Base
  def execute!
    card.fetch('actions', []).each do |action|
      action.each { |k, v| send(k, v) }
    end
    current_player.deck.discard(card)
    gameplay_data
  end

  def card
    @card ||= Base::CARDS.find { |data| data['name'] == type }
  end

  %i[cards health attack_points move_points coins
     clank teleport_points skill_points].each do |type|
    define_method(type) do |v = value|
      current_player.public_send("#{type}=", current_player.public_send(type) + v)
    end
  end

  def draw(val = value)
    current_player.deck.draw(val)
  end

  def dragon_clank
    gameplay_data.dragon.clank += value
  end

  def trash
    # test
    current_player.rewards << value
  end
end
