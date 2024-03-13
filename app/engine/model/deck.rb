# frozen_string_literal: true

class Model::Deck
  attr_accessor :active, :deck, :discarded, :num_of_active_cards

  def initialize(cards, num_of_active_cards: 5)
    cards.shuffle!
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
    cards = deck.pop(number_of_cards)
    if (cards_needed = number_of_cards - cards.length).positive?
      reload_deck
      cards.concat(deck.pop(cards_needed))
    end
    active.concat(cards)
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
