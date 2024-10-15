# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Clank::Model::Player do
  let(:player_data) { JSON.parse(file_fixture('clank/new_game.json').read)['players'][0] }

  let(:player) { described_class.from_json(player_data) }

  describe '.from_json' do
    it 'initializes a player from JSON data' do
      expect(player.position).to be_a(Clank::Model::Position)
      expect(player.deck).to be_a(Model::Deck)
      expect(player.coins).to eq(player_data['coins'])
    end
  end

  describe '#initialize' do
    it 'initializes with default values when no parameters are passed' do
      new_player = described_class.new
      expect(new_player.coins).to eq(described_class::START_COINS)
      expect(new_player.clank).to eq(described_class::STARTING_CLANK_CUBES[0])
      expect(new_player.health).to eq(described_class::MAX_HEALTH)
      expect(new_player.inventory).to be_empty
    end

    it 'initializes with provided parameters' do
      new_player = described_class.new(name: 'Player 1', coins: 5, health: 8)
      expect(new_player.name).to eq('Player 1')
      expect(new_player.coins).to eq(5)
      expect(new_player.health).to eq(8)
    end
  end

  describe '#clank=' do
    it 'sets the clank value and does not allow negative clank' do
      player.clank = -5
      expect(player.clank).to eq(0)

      player.clank = 10
      expect(player.clank).to eq(10)
    end
  end

  describe '#inactive_clank' do
    it 'returns the inactive clank value when clank exceeds MAX_CLANK' do
      player.clank = 35
      expect(player.inactive_clank).to eq(5)
    end
  end

  describe '#depths?' do
    it 'returns whether the player is in the depths' do
      allow(player.position).to receive(:depths?).and_return(true)
      expect(player.depths?).to be(true)
    end
  end

  describe '#artifact?' do
    it 'returns true if player has an artifact in inventory' do
      player.inventory = [{ 'is_artifact' => true }]
      expect(player.artifact?).to be(true)
    end

    it 'returns false if player does not have an artifact in inventory' do
      player.inventory = [{ 'is_artifact' => false }]
      expect(player.artifact?).to be(false)
    end
  end

  describe '#reset!' do
    it 'resets player attributes to default values' do
      player.reset!
      expect(player.attack_points).to eq(0)
      expect(player.move_points).to eq(0)
      expect(player.skill_points).to eq(0)
      expect(player.rewards).to be_empty
      expect(player.trash_options).to be_empty
      expect(player.ignore_monster_path).to be(false)
      expect(player.skip_crystal_cave).to be(false)
      expect(player.discard_number).to eq(0)
      expect(player.moved_to_crystal_cave).to be(false)
      expect(player.replace_card_points).to eq(0)
    end
  end
end
