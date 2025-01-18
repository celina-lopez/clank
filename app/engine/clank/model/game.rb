# frozen_string_literal: true

class Clank::Model::Game < Model::Game
  attr_accessor :deck, :marketplace, :map, :dragon, :marketplace_items

  def self.from_json(json)
    new(
      dragon: Clank::Model::Dragon.from_json(json['dragon']),
      deck: Model::Deck.from_json(json['deck']),
      map: Clank::Model::Map.from_json(json['map']),
      players: json['players'].map { |p| Clank::Model::Player.from_json(p) },
      **json.symbolize_keys.reject { |k, _v| %i[dragon deck map players].include?(k) }
    )
  end

  def initialize(
    dragon: nil,
    deck: Model::Deck.new(Clank::Base::STARTING_GAME_CARDS, num_of_active_cards: 6),
    marketplace: Clank::Base::MARKETPLACE,
    map: Clank::Model::Map.new,
    marketplace_items: Clank::Base::MARKETPLACE_ITEMS,
     **kwargs
  )
    super
    @dragon = dragon || Clank::Model::Dragon.new(num_players: kwargs[:new_players]&.length)
    @map = map
    @deck = deck
    @marketplace = marketplace
    @marketplace_items = marketplace_items
  end

  def next_player!
    current_player.reset!
    current_player.deck.reload_active_deck
    activate_current_player_actions
    super
  end

  private

  def activate_current_player_actions
    active_actions = current_player.deck.active.flat_map do |x|
      x.fetch('actions', []).first&.keys
    end & %w[ignore_monster_path skip_crystal_cave]
    active_actions.each { |action| current_player.send("#{action}=", true) } if active_actions.any?
  end
end
