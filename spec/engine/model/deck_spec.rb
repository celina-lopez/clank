# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Model::Deck do
  let(:cards) do
    [
      { 'name' => 'card1', 'total' => 2 },
      { 'name' => 'card2', 'total' => 3 },
      { 'name' => 'card3', 'total' => 1 }
    ]
  end
  let(:deck) { Model::Deck.new(cards) }

  describe '#initialize_new_deck' do
    it 'initializes a new deck' do
      deck.initialize_new_deck(cards)
      expect(deck.active.length).to eq(5)
      expect(deck.deck.length).to eq(1)
      expect(deck.discarded.length).to eq(0)
    end
  end

  describe '#discard' do
    let(:card) { { 'name' => 'card1' } }
    it 'discards a card' do
      deck.discard(card)
      expect(deck.active.length).to eq(4)
      expect(deck.discarded.length).to eq(1)
    end
  end

  describe '#initialize_deck' do
    it 'initializes a deck' do
      total_cards = deck.initialize_deck(cards)
      expect(total_cards.length).to eq(6)
    end
  end

  describe '#draw' do
    let(:card) { { 'name' => 'card1' } }
    before do
      deck.discard(card)
    end
    it 'draws a card' do
      expect { deck.draw(2) }.to change { deck.active.length }.by(2)
      expect(deck.discarded.length).to eq(0)
    end
  end

  describe '#destroy!' do
    let(:card) { { 'name' => 'card1' } }
    it 'destroys a card' do
      expect { deck.destroy!(card) }.to change { deck.active.length }.by(-1)
    end
  end

  describe '#reload_active_deck' do
    before do
      deck.discarded.concat(deck.active)
      deck.active = []
    end
    it 'reloads the active deck' do
      expect { deck.reload_active_deck }
        .to change { deck.active.length }.by(5)
        .and change { deck.discarded.length }.by(-5)
    end
  end

  describe '#full_deck' do
    it 'returns the full deck' do
      expect(deck.full_deck.length).to eq(6)
    end
  end
end
