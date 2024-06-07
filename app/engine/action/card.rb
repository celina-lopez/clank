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
  x
  %i[cards health attack_points move_points coins
     clank teleport_points skill_points replace_card_points].each do |type|
    define_method(type) do |v = value|
      current_player.public_send("#{type}=", current_player.public_send(type) + v)
    end
  end

  %i[ignore_monster_path skip_crystal_cave].each do |type|
    define_method(type) do |v = value|
      current_player.public_send("#{type}=", v)
    end
  end

  def draw(val = value)
    current_player.deck.draw(val)
  end

  def other_clank(val = value)
    gameplay_data.players.each do |player|
      player.clank += val if player != current_player
    end
  end

  def dragon_clank
    gameplay_data.dragon.clank += value
  end

  def trash_options(_val = value)
    current_player.trash_options << value
  end
end
