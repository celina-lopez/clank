# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoveLetter::Model::Game do
  let(:gameplay_data) { JSON.parse(file_fixture('love_letter/new_game.json').read) }
  let(:game) { described_class.from_json(gameplay_data) }

  describe '.from_json' do
    it 'initializes a game from JSON' do
      expect(game.deck).to be_a(Model::Deck)
      expect(game.players.count).to eq(gameplay_data['players'].count)
    end
  end

  describe '#initialize' do
    let(:new_players) { ['Player 1', 'Player 2'] }

    it 'initializes with new players if provided' do
      new_game = described_class.new(new_players:)
      expect(new_game.players.count).to eq(new_players.count)
    end

    it 'initializes with default values when no players are provided' do
      expect(game.deck.active.count).to eq(0)
    end
  end

  describe '#next_player!' do
    it 'resets the current player and reloads their active deck' do
      current_player = game.current_player
      expect(current_player).to receive(:reset!)
      game.next_player!
    end
  end
end
