# frozen_string_literal: true

class Action::Card < Action::Base
  def execute!
    if card.nil?
      send(type)
      return gameplay_data
    end
    redeem_card_rewards
  end

  def card
    @card ||= Base::CARDS.find { |data| data['name'] == type }
  end

  %i[cards health attack_points move_points coins
     clank teleport_points skill_points replace_card_points
     discard_number].each do |type|
    define_method(type) do |v = value|
      history << { type:, value: v, player_index: current_player_index }
      current_player.public_send("#{type}=", current_player.public_send(type) + v)
    end
  end

  %i[ignore_monster_path
     skip_crystal_cave
     take_secret_adjacent
     spend_seven_for_two_secret_tomes].each do |type|
    define_method(type) do |v = value|
      history << { type:, value: v, player_index: current_player_index }
      current_player.public_send("#{type}=", v)
    end
  end

  def dragon_attack(val = value)
    history << { type: 'dragon_attack', value: val }
    action_game = Action::Game.new(gameplay_data, type: 'dragon_attack', value: val)
    action_game.dragon_attack!
    history.concat(action_game.history)
    # TODO: if person is dead, remove them from rotation, calculate victory points correctly
    self.gameplay_data = action_game.gameplay_data
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
