# frozen_string_literal: true

class Action::Game < Action::Base
  def end_turn # rubocop:disable Metrics/AbcSize
    loop do
      gameplay_data.next_player!
      break unless current_player.position.escape_tile?

      current_player.position.current_position = current_player.position.current_position - 1
      # TODO: make escape tiles minus on Map
      # TODO: dragon attack and progress
      return end_game! if current_player.position.end_tile?
    end
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
