# frozen_string_literal: true

class Model::Deck
  attr_accessor :active, :deck, :discarded, :num_of_active_cards

  def self.from_json(json)
    Model::Deck.new(
      num_of_active_cards: json['num_of_active_cards'],
      active: json['active'],
      deck: json['deck'],
      discarded: json['discarded']
    )
  end

  def initialize(cards = [], active: [], num_of_active_cards: 5, deck: [], discarded: [])
    @num_of_active_cards = num_of_active_cards
    if cards.present?
      initialize_new_deck(cards, num_of_active_cards:)
    else
      @active = active
      @deck = deck
      @discarded = discarded
    end
  end

  def initialize_new_deck(cards, num_of_active_cards: 5)
    deck = initialize_deck(cards)
    @active = deck.pop(num_of_active_cards)
    @deck = deck
    @discarded = []
  end

  def discard(card)
    active.delete_at(active.index(card))
    discarded << card
  end

  def initialize_deck(cards)
    total_cards = []
    cards.each do |card|
      card['total'].times { total_cards << card }
    end
    total_cards.shuffle!
  end

  def draw(number_of_cards)
    drawn_cards = deck.pop(number_of_cards)
    if (cards_needed = number_of_cards - drawn_cards.length).positive?
      reload_deck
      drawn_cards.concat(deck.pop(cards_needed))
    end
    active.concat(drawn_cards)
    drawn_cards
  end

  def destroy!(card)
    active.delete_at(active.index(card))
  end

  def reload_active_deck
    draw(num_of_active_cards - active.length)
  end

  private

  def reload_deck
    self.deck = discarded.shuffle!
    self.discarded = []
  end
end
