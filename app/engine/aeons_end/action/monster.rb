# frozen_string_literal: true

class AeonsEnd::Action::Monster < Base
  # TODO: add unleash max when more monsters?
  def unleash(value)
    gameplay_data.monster.unleash_points += value
    return unless gameplay_data.monster.unleash_points >= 4

    card = gameplay_data.monster.unleash_deck.draw(1)
    card['actions'].each do |action|
      send(action.first, action.last)
    end
    gameplay_data.monster.unleash_points -= 4
    gameplay_data.monster.unleash_deck.discard(card)
    gameplay_data
  end

  def gravehold_health(value)
    gameplay_data.gravehold += if value == 'this'
                                 value # FIXME: this should be the health of the town
                               else
                                 value
                               end
    gameplay_data
  end
end
