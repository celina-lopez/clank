# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Clank::Model::Game do
  let(:gameplay_data) { JSON.parse(file_fixture('clank/new_game.json').read) }
  let(:game) { described_class.from_json(gameplay_data) }

  describe '.from_json' do
    it 'initializes a game from JSON' do
      expect(game.dragon).to be_a(Clank::Model::Dragon)
      expect(game.deck).to be_a(Clank::Model::Deck)
      expect(game.marketplace).to eq(gameplay_data['marketplace'])
      expect(game.marketplace_items).to eq(gameplay_data['marketplace_items'])
      expect(game.map).to be_a(Clank::Model::Map)
      expect(game.players.count).to eq(gameplay_data['players'].count)
    end
  end

  describe '#initialize' do
    let(:new_players) { ['Player 1', 'Player 2'] }

    it 'initializes with new players if provided' do
      new_game = described_class.new(new_players:)
      expect(new_game.players.count).to eq(new_players.count)
      expect(new_game.dragon).to be_a(Clank::Model::Dragon)
    end

    it 'initializes with default values when no players are provided' do
      expect(game.dragon).to be_a(Clank::Model::Dragon)
      expect(game.deck.active_cards.count).to eq(6)
    end
  end

  describe '#next_player!' do
    it 'resets the current player and reloads their active deck' do
      current_player = game.current_player
      expect(current_player).to receive(:reset!)
      expect(current_player.deck).to receive(:reload_active_deck)
      game.next_player!
    end

    it 'activates current player actions' do
      allow(game.players[0].deck).to receive(:active).and_return([{ 'actions' => [{ 'ignore_monster_path' => true }] }])
      game.next_player!
      expect(game.players[0].ignore_monster_path).to be(true)
    end
  end
end
