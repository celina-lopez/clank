# frozen_string_literal: true

class AeonsEnd::Action::Card < Action::Card
  def execute!
    super
    redeem_card_rewards
    gameplay_data
  end
  %i[other_players_draws_cards_points discard_monster_top_card cast_other_player_prepped_spell_points].each do |type|
    define_method(type) do |v = value|
      history << { type:, value: v, player_index: current_player_index }
      current_player.public_send("#{type}=", current_player.public_send(type) + v)
    end
  end

  private

  def redeem_card_rewards
    if (actions = card.fetch('actions', [])).one?
      actions.first.each { |k, v| send(k, v) }
    elsif actions.any?
      current_player.rewards << actions
    end
    current_player.deck.discard(card)
    gameplay_data
  end
end
