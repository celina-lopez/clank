# frozen_string_literal: true

class Action::Player < Action::Base
  def buy_artifact # rubocop:disable Metrics/AbcSize
    item = gameplay_data.marketplace_items.find_by { |x| x['name'] == value }
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

  def move # rubocop:disable Metrics/AbcSize
    edge_metadata = current_player.position.edge_metadata(value)
    current_player.position.current_position = value

    pick_up_item(value)

    current_player.move_points -= edge_metadata.fetch('move', 1)
    current_player.health -= edge_metadata.fetch('danger', 0) unless current_player.ignore_monster_path
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

  def teleport # rubocop:disable Metrics/AbcSize
    current_player.position.current_position = value
    current_player.teleport -= 1
    pick_up_item(value)
    return unless current_player.position.tags(value).include?('crystal_cave')
    return unless current_player.skip_crystal_cave

    current_player.moved_to_crystal_cave = true
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
    inventory_item['actions'].each do |action_type, action_value|
      redeem_action_on_card(action_type, action_value)
    end
    current_player.inventory.delete_at(current_player.inventory.index(inventory_item))
  end

  def replace_card
    current_player.replace_card_points -= 1
    card_index = gameplay_data.deck.active.index { |x| x['name'] == value }
    gameplay_data.deck.active.delete_at(card_index)
  end

  private

  def pick_up_item(tile)
    tile_data = gameplay_data.map.tiles.find { |x| x['tile'] == tile }
    item = tile_data.fetch('items', []).pop
    current_player.inventory << item if item.present?
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

    current_player.deck.discarded << card
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
    Action::Card.new(gameplay_data, type: action_type, value: action_value).send(action_type)
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
