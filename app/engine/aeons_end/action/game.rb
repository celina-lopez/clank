# frozen_string_literal: true

class AeonsEnd::Action::Game < Action::Game
  def end_turn
    loop do
      gameplay_data.next_player!

      break if gameplay_data.current_player_index > -1

      fullfill_monster_actions
      gameplay_data.monster.deck.draw(1)
    end

    end_game! if gameplay_data.monster.dead? || gameplay_data.gravehold <= 0
  end

  def start_game
    self.gameplay_data = game_engine::Model::Game.new(new_players: value[:players])
  end

  private

  def fullfill_monster_actions
    gameplay_data.monster.deck.active.each do |card|
      if card['power'].present? && (card['power']).positive?
        card['power'] -= 1
      else
        card['actions'].each do |action|
          AeonsEnd::Action::Monster.new(gameplay_data).send(action.first, action.last)
        end
      end
      if card['power'].present? && card['power'].zero? || card['health'].present? && card['health'].zero?
        gameplay_data.monster.deck.discard(card)
      end
    end
  end
end
