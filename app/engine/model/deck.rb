# frozen_string_literal: true

class Model::Deck
  attr_accessor :active_deck, :deck, :discard_deck

  def initialize(cards)
    cards.shuffle!
    @active_deck = cards.pop(5)
    @deck = cards
    @discard_deck = []
  end

  def discard(card)
    active_deck.delete(card)
    discard_deck << card
  end

  def draw(number_of_cards)
    cards = deck.pop(number_of_cards)
    if (cards_needed = number_of_cards - cards.length).positive?
      reload_deck
      cards.concat(deck.pop(cards_needed))
    end
    active_deck.concat(cards)
  end

  def destroy!(card)
    active_deck.delete(card)
  end

  private

  def reload_deck
    self.deck = discard_deck.shuffle!
    self.discard_deck = []
  end
end
