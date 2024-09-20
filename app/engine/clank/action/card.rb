# frozen_string_literal: true

class Clank::Action::Card < Action::Card
  %i[coins clank replace_card_points discard_number].each do |type|
    define_method(type) do |v = value|
      history << { type:, value: v, player_index: current_player_index }
      current_player.public_send("#{type}=", current_player.public_send(type) + v)
    end
  end

  %i[ignore_monster_path skip_crystal_cave].each do |type|
    define_method(type) do |v = value|
      history << { type:, value: v, player_index: current_player_index }
      current_player.public_send("#{type}=", v)
    end
  end

  def dragon_attack(val = value)
    history << { type: 'dragon_attack', value: val }
    action_game = Clank::Action::Game.new(gameplay_data, type: 'dragon_attack', value: val)
    action_game.dragon_attack!
    history.concat(action_game.history)
    self.gameplay_data = action_game.gameplay_data
  end

  def other_clank(val = value)
    gameplay_data.players.each do |player|
      player.clank += val if player != current_player
    end
  end

  def dragon_clank
    gameplay_data.dragon.clank += value
  end

  def trash_options(val = value)
    current_player.trash_options << val
  end

  def increase_dragon
    gameplay_data.dragon.position += value
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
