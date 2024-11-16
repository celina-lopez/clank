# frozen_string_literal: true

class AeonsEnd::Action::Card < Action::Card
  def execute!
    super
    redeem_card_rewards
    gameplay_data
  end
  %i[discard_monster_top_card cast_other_player_prepped_spell_points].each do |type|
    define_method(type) do |v = value|
      history << { type:, value: v, player_index: current_player_index }
      current_player.public_send("#{type}=", current_player.public_send(type) + v)
    end
  end

  def other_players_draws_cards_points(v = value)
    history << { type: 'other_players_draws_cards_points', value: v, player_index: current_player_index }
    if gameplay_data.players.size > 2
      current_player.other_players_draws_cards_points = current_player.other_players_draws_cards_points + v
    elsif gameplay_data.players.size == 2
      other_player = gameplay_data.players.detect { |p| p.index != current_player_index }
      # TODO: its actually discard and then draw, so put in the other players rewards
      other_player.deck.draw(1)
    end
  end

  private

  def redeem_card_rewards
    if (actions = card.fetch('actions', [])).one?
      if (actions = actions.first).keys.include?('attack_points')
        current_player.add_to_breach(card)
      else
        actions.each { |k, v| send(k, v) }
      end
    elsif actions.any?
      current_player.rewards << actions
    end
    current_player.deck.discard(card)
    gameplay_data
  end
end
