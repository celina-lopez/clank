# frozen_string_literal: true

class Action::Card < Action::Base
  def execute!
    # TODO: clean this up plz
    card.fetch('actions', []).each do |action|
      action.each do |k, v|
        self.value = v
        send(k)
      end
    end
    current_player.deck.discard(card)
    gameplay_data
  end

  def card
    @card ||= Base::CARDS.find { |data| data['name'] == type }
  end

  %i[cards health attack_points move_points coins
     clank teleport skill_points].each do |type|
    define_method(type) do
      current_player.public_send("#{type}=", current_player.public_send(type) + value)
    end
  end

  def dragon_clank
    gameplay_data.dragon_clank += value
  end

  def trash
    # test
    current_player.rewards << value
  end
end
