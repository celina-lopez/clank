# frozen_string_literal: true

class Action::Card < Action::Base
  def execute!
    card.fetch('actions', []).each do |action|
      self.value = action.values.first
      send(action.keys.first)
    end
    current_player.deck.discard(card)
    gameplay_data
  end

  def card
    @card ||= Base::CARDS.find { |data| data['name'] == type }
  end

  %i[cards health attack_points move_points coins
     clank teleport skill_points].each do |type|
    define_method("add_#{type}") do
      current_player.public_send("#{type}=", current_player.public_send(type) + value)
    end
  end

  def add_dragon_cubes
    gameplay_data[:dragon_cubes] += value
  end

  def add_trash
    # test
    current_player.rewards << value
  end

  %i[clank].each do |type|
    define_method("remove_#{type}") do
      current_player.public_send("#{type}=", current_player.public_send(type) - value)
    end
  end
end
