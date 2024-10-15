# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Clank::Action::Player do
  subject { described_class.new(Clank::Model::Game.from_json(gameplay_data), type:, value:) }
  let(:type) { 'burgle' }
  let(:value) { 1 }

  let(:gameplay_data) { JSON.parse(file_fixture('clank/new_game.json').read) }
  let(:current_player) { subject.current_player }
  let(:deck) { instance_double('Deck', active: active_cards, discarded: discarded_cards) }
  let(:active_cards) { [{ 'name' => 'card_name' }] }
  let(:discarded_cards) { [] }
  let(:marketplace) { [{ 'name' => 'card', 'total' => 1 }] }
  let(:marketplace_items) { [{ 'name' => 'artifact', 'total' => 1 }] }
  let(:position) { instance_double('Position') }

  describe '#buy_artifact' do
    let(:value) { 'key' }

    it 'reduces coins and adds artifact to inventory' do
      expect(subject.current_player.coins).to eq(7)

      subject.buy_artifact

      expect(subject.current_player.coins).to eq(0)
      expect(subject.current_player.inventory).to include(hash_including({ 'name' => 'key' }))
    end
  end

  describe '#buy_card' do
    let(:value) { 'explore' }

    it 'redeems a card from the marketplace and reduces total' do
      allow(subject.current_player).to receive(:skill_points).and_return(5)
      expect(subject.gameplay_data.marketplace.first['total']).to eq(15)

      subject.buy_card

      expect(subject.gameplay_data.marketplace.first['total']).to eq(14)
      expect(current_player.deck.discarded).to include(hash_including({ 'name' => 'explore' }))
    end
  end

  describe '#play_all_cards' do
    it 'plays all cards and discards them' do
      expect(subject.current_player.deck.active).not_to be_empty

      subject.play_all_cards

      expect(subject.current_player.deck.active).to be_empty
    end
  end

  describe '#move' do
    let(:value) { 1 }
    let(:edge_metadata) { { 'move' => 1, 'danger' => -1 } }
    let(:tile_tags) { [] }

    it 'updates the player position and reduces move points' do
      allow(subject.gameplay_data.players[0].position).to receive(:edge_metadata).with(value).and_return(edge_metadata)
      allow(subject.gameplay_data.players[0].position).to receive(:tags).with(value).and_return(tile_tags)

      subject.move

      expect(subject.current_player.position.current_position).to eq(value)
      expect(subject.current_player.move_points).to eq(-1)
    end
  end

  describe '#trash' do
    let(:value) { 'card_name,active' }

    it 'removes the specified card from the player’s deck' do
      allow(current_player.deck).to receive(:active).and_return([{ 'name' => 'card_name' }])

      subject.trash

      expect(current_player.deck.active).not_to include({ 'name' => 'card_name' })
    end
  end

  describe '#redeem_reward' do
    let(:value) { '0,1' }
    let(:reward) { [{ 'move_points' => 2 }, { 'attack_points' => 2 }] }

    it 'redeems the specified reward' do
      allow(current_player).to receive(:rewards).and_return([reward])

      subject.redeem_reward

      expect(current_player.rewards).to be_empty
    end
  end

  describe '#redeem_inventory_item' do
    let(:value) { 'artifact' }
    let(:inventory_item) { { 'name' => 'artifact', 'action' => [{ 'move_points' => 100 }] } }

    it 'redeems an inventory item and performs its actions' do
      allow(subject.current_player).to receive(:inventory).and_return([inventory_item])

      subject.redeem_inventory_item

      expect(subject.current_player.inventory).not_to include(inventory_item)
    end
  end

  describe '#replace_card' do
    let(:value) { 'brilliance' }

    it 'removes a card from the active deck and reduces replace card points' do
      expect(subject.gameplay_data.deck.active).to include(hash_including({ 'name' => 'brilliance' }))

      subject.replace_card

      expect(current_player.replace_card_points).to eq(-1)
      expect(subject.gameplay_data.deck.active).not_to include(hash_including({ 'name' => 'brilliance' }))
    end
  end
end
