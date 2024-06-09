# frozen_string_literal: true

class Validation::Player < Validation::Base
  def attack?
    add_error_if_error('Not enough attack points', current_player.attack_points >= value)
  end

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
    result && validate_health
  end

  def move? # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    next_to = current_player.position.next_to?(value)
    add_error_if_error('Cant go to tile', next_to)
    unless current_player.skip_crystal_cave
      add_error_if_error('Cant move if you been in a crystal cave', !current_player.moved_to_crystal_cave)
    end
    edge_metadata = current_player.position.edge_metadata(value)
    move_points = edge_metadata.fetch('move', 1)
    add_error_if_error('Not enough move points', current_player.move_points >= move_points)
    locked = edge_metadata.fetch('locked', false)
    add_error_if_error("Player doesn't have lock", current_player.inventory.find { |x| x['name'] == 'key' }) if locked
    return if current_player.ignore_monster_path

    danger = edge_metadata.fetch('danger', 0)
    add_error_if_error("Player doesn't have enough health", (current_player.health - danger).positive?)
  end

  def teleport?
    next_to = add_error_if_error('Not next to tile', current_player.position.next_to?(value))
    next_to && add_error_if_error('No teleport availabile', current_player.teleport.positive?)
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
    add_error_if_error('Not enough replace_card points', current_player.replace_card_points.positive?)
    replace_card = gameplay_data.deck.active.find { |x| x['name'] == value }
    add_error_if_error('Card not found', replace_card.present?)
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

  def card
    @card ||= CARDS.find { |x| x['name'] == value }
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

  def validate_buy_conditions # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
    return true unless card['conditions'].present?

    card['conditions'].all? do |condition|
      if condition['type'] == 'can_buy'
        if condition['has'].present?
          current_player.inventory.any? { |x| x['name'] == condition['has'] } # TODO: double check item theme all
        elsif condition['has_companion'].present?
          current_player.deck.active.any? { |x| Base::COMPANION_NAMES.include?(x['name']) }
        elsif condition['two_of'].present?
          current_player.inventory.select { |x| x['name'] == condition['two_of'] }.count >= 2
        elsif condition['is_in'].present?
          current_player.position.public_send("#{condition['is_in']}?")
        else
          raise StandardError, 'UHHHHH what?'
        end
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
