# frozen_string_literal: true

class Clank::Validation::Player < Validation::Player
  def redeem_reward?
    add_error_if_error('Invalid format', current_player.rewards.dig(*value.split(',').map(&:to_i)).present?)
  end

  def buy?
    result = add_error_if_error('Not in marketplace', current_player.position.marketplace?)
    result && add_error_if_error("Need #{current_player.coins - value} coins", current_player.coins >= value)
  end

  def buy_card?
    result = add_error_if_error('Card not found', card)
    result &= validate_funds
    result &= validate_health
    result && validate_buy_conditions
  end

  def move? # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    next_to = current_player.position.next_to?(value)
    ok = add_error_if_error('Please choose adjacent tile', next_to)
    return ok unless ok

    if value.to_i.zero?
      ok &= add_error_if_error('You dont have an artificat', current_player.inventory.any? { |x| x['is_artifact'] })
    end
    unless current_player.skip_crystal_cave
      ok &= add_error_if_error('Cant move if you been in a crystal cave', !current_player.moved_to_crystal_cave)
    end
    edge_metadata = current_player.position.edge_metadata(value)
    move_points = edge_metadata.fetch('move', 1)
    ok &= add_error_if_error('Not enough move points', current_player.move_points >= move_points)
    locked = edge_metadata.fetch('locked', false)
    if locked
      ok &= add_error_if_error("Player doesn't have lock", current_player.inventory.find do |x|
                                                             x['name'] == 'key'
                                                           end)
    end
    return if current_player.ignore_monster_path

    danger = edge_metadata.fetch('danger', 0)
    ok &= add_error_if_error("Player doesn't have enough health", (current_player.health - danger).positive?)
    ok
  end

  def trash?
    card_name, card_deck = value.split(',')
    validate_trash_options(card_name)
    card_index = nil
    %w[active discarded].each do |deck|
      next unless card_deck == deck || card_deck.nil?

      card_index = current_player.deck.send(deck).index { |x| x['name'] == card_name }
    end
    add_error_if_error('Card not found', card_index.present?)
  end

  def replace_card?
    ok = add_error_if_error('Not enough replace_card points', current_player.replace_card_points.positive?)
    replace_card = gameplay_data.deck.active.find { |x| x['name'] == value }
    ok && add_error_if_error('Card not found', replace_card.present?)
  end

  def redeem_inventory_item?
    item = current_player.inventory.find { |x| x['name'] == value }
    ok = add_error_if_error('Card not found', item.present?)
    ok && add_error_if_error('Card is not actionable', item['action'].present?)
  end

  def buy_artifact?
    item = gameplay_data.marketplace_items.find { |x| x['name'] == value }
    ok = add_error_if_error('artifact not found', item.present?)
    ok && add_error_if_error('Cant afford', current_player.coins >= 7)
  end

  private

  def validate_trash_options(card_name)
    trash_index = current_player.trash_options.find { |x| x.keys.first == card_name if x.is_a?(Hash) }
    unless trash_index.present?
      trash_index = current_player.trash_options.find do |x|
        !x.is_a?(Hash) && x.to_i.positive?
      end
    end
    add_error_if_error('Trash option not found', trash_index.present?)
  end

  def validate_funds
    return true unless card['cost'].present?

    cost = card['cost'].to_i
    cost -= 2 if gem_card_conditional?
    result = current_player.skill_points >= cost
    add_error_if_error("Need #{card['cost'] - current_player.skill_points} more skill points", result)
  end

  def validate_health
    return true unless card['health'].present?

    result = current_player.attack_points >= card['health'].to_i
    add_error_if_error("Need #{card['health'] - current_player.attack_points} more attack points", result)
  end

  def validate_buy_conditions
    return true unless card['conditions'].present?

    card['conditions'].all? do |condition|
      if condition['type'] == 'can_buy'
        result = current_player.position.public_send("#{condition['is_in']}?")
        add_error_if_error("Not in #{condition['is_in'].humanize}", result)
      else
        true
      end
    end
  end

  def gem_card_conditional?
    has_gem_collector = current_player.deck.active.find { |x| x['name'] == 'gem_collector' }
    return false unless has_gem_collector

    GEM_CARD_NAMES.include?(value)
  end
end
