# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Clank::Validation::Player do
  let(:gameplay_data) { JSON.parse(file_fixture('clank/new_game.json').read) }
  subject(:validator) do
    described_class.new(Clank::Model::Game.from_json(gameplay_data), player_index: 0, type:, value:)
  end

  describe '#redeem_reward?' do
    let(:type) { 'redeem_reward' }
    let(:value) { '' }
    it 'returns false and adds an error when reward is invalid' do
      expect(validator).to receive(:add_error_if_error).with('Invalid format', false)
      validator.redeem_reward?
    end
  end

  describe '#buy?' do
    let(:type) { 'buy' }
    before do
      gameplay_data['players'][0]['coins'] = 4
    end
    it 'returns true if player is in marketplace and has enough coins' do
      expect(validator).to receive(:add_error_if_error).with('Not in marketplace', true)
      expect(validator).to receive(:add_error_if_error).with('Need 3 coins', true)
      validator.buy?
    end
  end

  describe '#buy_card?' do
    let(:type) { 'buy_card' }
    context 'when player has enough skill points' do
      let(:value) { 'brilliance' }
      it 'validates buy card process successfully' do
        expect { validator.valid? }.to raise_error(Validation::Base::InvalidMoveError, 'Need 6 more skill points')
      end
    end

    context 'when player has enough attack points' do
      let(:value) { 'goblin' }
      it 'validates buy card process successfully' do
        expect { validator.valid? }.to raise_error(Validation::Base::InvalidMoveError, 'Need 2 more attack points')
      end
    end

    context 'when player doesnt meet conditions' do
      let(:value) { 'the_vault' }
      it 'validates buy card process successfully' do
        expect { validator.valid? }.to raise_error(Validation::Base::InvalidMoveError, 'Not in depths')
      end
    end

    context 'when player meets conditions' do
      let(:value) { 'brilliance' }
      before do
        gameplay_data['players'][0]['skill_points'] = 6
      end
      it 'validates buy card process successfully' do
        expect(validator.valid?).to be_truthy
      end
    end
  end

  pending '#move?' do
    it 'returns true when player can move to the next tile' do
      expect(validator).to receive(:add_error_if_error).with('Please choose adjacent tile', true)
      expect(validator).to receive(:add_error_if_error).with('Not enough move points', true)
      validator.move?
    end
  end

  pending '#trash?' do
    it 'returns false if card is not found in active or discarded deck' do
      expect(validator).to receive(:validate_trash_options).with('some_value')
      expect(validator).to receive(:add_error_if_error).with('Card not found', false)
      validator.trash?
    end
  end

  pending '#replace_card?' do
    it 'returns false if player has no replace card points' do
      expect(validator).to receive(:add_error_if_error).with('Not enough replace_card points', false)
      validator.replace_card?
    end
  end

  pending '#redeem_inventory_item?' do
    it 'returns false if item is not found in inventory' do
      expect(validator).to receive(:add_error_if_error).with('Card not found', false)
      validator.redeem_inventory_item?
    end
  end

  pending '#buy_artifact?' do
    let(:marketplace_item) { { 'name' => 'artifact' } }

    before { allow(gameplay_data).to receive(:marketplace_items).and_return([marketplace_item]) }

    it 'returns true if artifact is found and player has enough coins' do
      expect(validator).to receive(:add_error_if_error).with('artifact not found', true)
      expect(validator).to receive(:add_error_if_error).with('Cant afford', true)
      validator.buy_artifact?
    end
  end
end
