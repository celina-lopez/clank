# frozen_string_literal: true

class Clank::Action::Game < Action::Game
  def end_turn # rubocop:disable Metrics/AbcSize
    loop do
      gameplay_data.next_player!
      break unless current_player.position.escape_tile? && current_player.artifact?
      return end_game! if gameplay_data.players.size == 1

      current_player.position.current_position -= 1
      return end_game! if current_player.position.end_tile?

      dragon_attack!
    end
    drawn_cards = gameplay_data.deck.reload_active_deck
    fullfill_immediate_actions(drawn_cards)
  end

  def dragon_attack! # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    bag = gameplay_data.players.flat_map do |player|
      player.clank.times.map { player.index }
    end

    bag += gameplay_data.dragon.clank.times.map { -1 }
    hits = bag.sample(gameplay_data.dragon.num_of_hits)
    hits.each do |hit|
      if hit == -1
        gameplay_data.dragon.clank -= 1
      else
        gameplay_data.players[hit].health -= 1
        gameplay_data.players[hit].clank -= 1
      end
      history << { type: 'dragon_clank', value: hit }
    end
  end

  def increase_dragon
    gameplay_data.dragon.position = gameplay_data.dragon.position + 1
  end

  private

  def fullfill_immediate_actions(newly_drawn_cards)
    immediate_actions = newly_drawn_cards.flat_map do |card|
      card.fetch('immediate_actions', [])
    end
    immediate_actions.each do |action|
      action_data = action.to_a.first
      klass_type = Engine.klass_type(action_data[0])
      Action.const_get(klass_type).new(gameplay_data, type: action_data[0], value: action_data[1]).execute!
      history << { type: action_data[0], value: action_data[1] }
    end
  end
end
