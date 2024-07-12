# frozen_string_literal: true

class Action::Player < Action::Base
  def buy_artifact # rubocop:disable Metrics/AbcSize
    item = gameplay_data.marketplace_items.find { |x| x['name'] == value }
    current_player.coins -= 7
    current_player.inventory << item
    item['total'] -= 1
    return unless item['total'].zero?

    gameplay_data.marketplace_items.delete_at(gameplay_data.marketplace_items.index(item))
  end

  def buy_card
    card = gameplay_data.deck.active.find { |x| x['name'] == value }
    if card.present?
      discard_from_deck(card)
    else
      card = gameplay_data.marketplace.find { |x| x['name'] == value }
      card['total'] -= 1
      gameplay_data.marketplace.delete(card) if card['total'].zero? && card['name'] != 'goblin'
    end
    redeem_card(card)
  end

  def play_all_cards
    card_klass = Action::Card.new(gameplay_data, type: nil, value: nil)
    active_cards = current_player.deck.active.dup
    active_cards.each do |card|
      if (actions = card.fetch('actions', [])).one?
        actions.first.each { |k, v| card_klass.send(k, v) }
      elsif actions.any?
        current_player.rewards << actions
      end
      current_player.deck.discard(card)
    end
  end

  def move # rubocop:disable Metrics/AbcSize
    edge_metadata = current_player.position.edge_metadata(value)
    current_player.position.current_position = value

    pick_up_item(value)

    current_player.move_points -= edge_metadata.fetch('move', 1)
    remove_health(edge_metadata.fetch('danger', 0)) unless current_player.ignore_monster_path
    return unless current_player.position.tags(value).include?('crystal_cave')
    return if current_player.skip_crystal_cave

    current_player.moved_to_crystal_cave = true
  end

  def trash
    card_name, card_deck = value.split(',')
    remove_trashed_option(card_name)

    %w[active discarded].each do |deck|
      next unless card_deck == deck || card_deck.nil?

      card_index = current_player.deck.send(deck).index { |x| x['name'] == card_name }
      current_player.deck.send(deck).delete_at(card_index) if card_index.present?
    end
  end

  def redeem_reward
    indexes = value.split(',').map(&:to_i)
    reward = current_player.rewards.dig(*indexes)
    reward.each do |action_key, action_value|
      redeem_action_on_card(action_key, action_value)
    end
    current_player.rewards.delete_at(indexes.first)
  end

  def redeem_inventory_item
    inventory_item = current_player.inventory.find { |x| x['name'] == value }
    inventory_item.fetch('action', []).each do |action|
      action.each do |action_type, action_value|
        redeem_action_on_card(action_type, action_value)
      end
    end
    current_player.inventory.delete_at(current_player.inventory.index(inventory_item))
  end

  def replace_card
    current_player.replace_card_points -= 1
    card_index = gameplay_data.deck.active.index { |x| x['name'] == value }
    gameplay_data.deck.active.delete_at(card_index)
  end

  private

  def remove_health(danger)
    danger -= current_player.attack_points if current_player.attack_points.positive?
    return if danger.negative?

    current_player.health -= danger
  end

  def pick_up_item(tile)
    tile_index = gameplay_data.map.tiles.index { |x| x['tile'] == tile.to_i }
    tile_data = gameplay_data.map.tiles[tile_index]
    item = tile_data.fetch('items', []).pop
    return unless item.present?

    return if replace_or_pick_artifact(item)

    current_player.inventory << item
    if item['on_acquire'].present?
      item['on_acquire'].each do |action_key, action_value|
        redeem_action_on_card(action_key, action_value)
      end
    end
    history << { type: 'picked_up_item', value: item['name'], player_index: current_player.index }
  end

  def replace_or_pick_artifact(item)
    return false unless item['is_artifact']

    player_artifacts = current_player.inventory.filter { |x| x['is_artifact'] }
    return false if player_artifacts.empty?

    backpack_size = current_player.inventory.filter { |x| x['name'] == 'backpack ' }.size

    return false if backpack_size > player_artifacts.size

    lowest_artifact = player_artifacts.sort_by! { |x| x['victory_points'] }.first
    if lowest_artifact['victory_points'] < item['victory_points']
      current_player.inventory.delete_at(current_player.inventory.index(lowest_artifact))
      tile_data['items'] << lowest_artifact
      current_player.inventory << item
      history << { type: 'picked_up_item', value: item['name'], player_index: current_player.index }
    end
    true
  end

  def remove_trashed_option(card_name)
    current_player.trash_options = current_player.trash_options.map do |x|
      if x.is_a?(Hash) && x.keys.first == card_name
        nil
      elsif x.is_a?(Hash)
        x
      elsif x.to_i > 1
        x - 1
      end
    end.compact
  end

  def redeem_cost(card)
    cost = card['cost'].to_i
    cost -= 2 if gem_card_conditional?
    current_player.skill_points -= cost
  end

  def pay_with_attack_points(card)
    current_player.attack_points -= card['health']
  end

  def redeem_card(card)
    pay_with_attack_points(card) if card['health'].present?
    redeem_cost(card) if card['cost'].present?
    card_on_acquire(card)
    return if card['health'].present? || Base::DEVICE_CARD_NAMES.include?(card['name'])

    # TODO: position of monkey idol is way off on phaser, also it should costtwo more steps to go there perhpas
    new_card = card.dup
    new_card.delete('cost')
    current_player.deck.discarded << new_card
  end

  def card_on_acquire(card)
    if (acquire = card.fetch('acquire', [])).one?
      acquire.first.each do |k, v|
        redeem_action_on_card(k, v)
      end
    elsif acquire.present?
      current_player.rewards << acquire
    end
  end

  def redeem_action_on_card(action_type, action_value)
    history << { type: action_type, value: action_value, player_index: current_player.index }
    card_engine = Action::Card.new(gameplay_data, type: action_type, value: action_value)
    card_engine.send(action_type)
    history.concat(card_engine.history)
  end

  def discard_from_deck(card)
    return if card['name'] == 'goblin'

    gameplay_data.deck.destroy!(card)
  end

  def gem_card_conditional?
    has_gem_collector = current_player.deck.active.find { |x| x['name'] == 'gem_collector' }
    return false unless has_gem_collector

    GEM_CARD_NAMES.include?(value)
  end
end
