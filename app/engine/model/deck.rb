# frozen_string_literal: true

class Model::Deck
  attr_accessor :active, :deck, :discarded, :num_of_active_cards

  def initialize(cards, num_of_active_cards: 5)
    cards = cards.dup.shuffle!
    @num_of_active_cards = num_of_active_cards
    @active = cards.pop(num_of_active_cards)
    @deck = cards
    @discarded = []
  end

  def discard(card)
    active.delete(card)
    discarded << card
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
    active.delete(card)
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
