# frozen_string_literal: true

class Action::Game < Action::Base
  def end_turn
    gameplay_data.next_player!
    return end_game! if end_game?

    drawn_cards = gameplay_data.deck.reload_active_deck
    fullfill_immediate_actions(drawn_cards)
  end

  def start_game
    self.gameplay_data = Model::Game.new(num_players: value.to_i)
  end

  private

  def end_game!
    CalculateVictoryPoints.new(gameplay_data).execute!
  end

  def end_game?
    false
    # player has certain position metadata
    # gameplay_data.current_player.position == [0, 0]
  end

  def fullfill_immediate_actions(newly_drawn_cards)
    # TODO: dragon attack?
    immediate_actions = newly_drawn_cards.flat_map do |card|
      card.fetch('immediate_actions', [])
    end
    immediate_actions.each do |action|
      klass_type = Engine.klass_type(action['type'])
      Action.const_get(klass_type).new(gameplay_data, type: action['type'], value: action['value']).execute!
    end
  end
end
